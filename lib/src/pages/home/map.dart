import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';
import 'package:history_go/src/services/place_repository.dart';
import 'package:history_go/src/pages/pages.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _completer;
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final FirestoreService _firestoreService = FirestoreService();

  HashSet<Place> places = new HashSet();
  HashSet<Place> nearbyPlaces = HashSet();
  LatLngBounds _nearbyUserArea;

  int _markerIdCounter = 1;
  MarkerId selectedMarker;

  LatLng _userPosition;
  LatLng _lastCall;

  double placeSeenColor = BitmapDescriptor.hueYellow;
  double placeNearbyColor = BitmapDescriptor.hueGreen;
  double placeNotSeenColor = BitmapDescriptor.hueRed;

  StreamSubscription positionStream;
  Geolocator _geolocator = Geolocator();
  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 3);

  double _zoom = 17.0;

  @override
  void initState() {
    super.initState();
    _completer = new Completer();

    print("Starting stream");
    positionStream =
        _geolocator.getPositionStream(locationOptions).listen((position) {
      setState(() {
        _userPosition = _toLatLng(position);
      });
      userMoveHandler();
    });
  }

  void userMoveHandler() async {
    await _completer.future.then((controller) => _controller = controller);

    updatePlaces();

    if (_completer.isCompleted)
      _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _userPosition, zoom: await _controller.getZoomLevel())));
  }

  Future<bool> shouldUpdateShownPlaces() async {
    if (_lastCall == null) {
      print("first");
      _lastCall = _userPosition;
      return true;
    }
    if (_lastCall == _userPosition) return false;
    double distance = await distanceBetween(_lastCall, _userPosition);
    print(distance);
    return distance > 150;
  }

  Future<double> distanceBetween(LatLng first, LatLng second) async {
    double distance = await _geolocator.distanceBetween(
        first.latitude, first.longitude, second.latitude, second.longitude);
    return Future.value(distance);
  }

  void updatePlaces() async {
    print(this.toDiagnosticsNode().toString() +
        " \nis mounted:" +
        this.mounted.toString());
    if (this.mounted) {
      shouldUpdateShownPlaces().then((result) {
        if (result) {
          print("updating places");
          PlaceRepository()
              .getBoundedPlaces(getAreaAroundUser(_userPosition, Size.big))
              .then((updated) {
            _lastCall = _userPosition;
            setState(() {
              places = updated;
            });
            updateNearbyPlaces();
            setMarkers();
          });
        } else {
          updateNearbyPlaces();
          setMarkers();
        }
      });
    }
  }

  void updateNearbyPlaces() {
    print("updating nearby places");
    if (this.mounted) {
      _nearbyUserArea = getAreaAroundUser(_userPosition, Size.small);
      HashSet<Place> temp = HashSet.from(
          places.where((p) => _nearbyUserArea.contains(p.position)));
      print(temp.length);
      setState(() {
        nearbyPlaces = temp;
      });
    }
  }

  LatLngBounds getAreaAroundUser(LatLng position, Size size) {
    double w;
    double h;
    switch (size) {
      case Size.big:
        w = .015;
        h = .007;
        break;
      case Size.small:
        w = .0016;
        h = .0008;
        break;
    }
    LatLng sw = LatLng(position.latitude - h, position.longitude - w);
    LatLng ne = LatLng(position.latitude + h, position.longitude + w);
    return new LatLngBounds(southwest: sw, northeast: ne);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _userPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    _completer.complete(controller);
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: _userPosition,
                  zoom: _zoom,
                ),
                mapType: MapType.normal,
                markers: Set<Marker>.of(markers.values),
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
              ),
            ),
    );
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            placeSeenColor,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void addMarker(Place place) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    bool nearby = nearbyPlaces.contains(place);
    bool visited = hasVisited(place);
    double iconColor = nearby ? placeNearbyColor : placeNotSeenColor;
    if (visited) iconColor = placeSeenColor;

    final Marker marker = Marker(
        markerId: markerId,
        position: place.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(iconColor),
        consumeTapEvents: true,
        onTap: () {
          print("Nearby contains place? ${nearbyPlaces.contains(place)}");
          if (nearby || visited) {
            _onMarkerTapped(markerId);
            saveAsVisited(place);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InfoPage(place)));
          }
        });
    setState(() {
      markers[markerId] = marker;
    });
  }

  void setMarkers() {
    debugPrint("Setting markers");
    markers.clear();
    for (Place p in places) {
      addMarker(p);
    }
  }

  void saveAsVisited(Place place) {
    User user = Globals.instance.user;
    HashSet<String> visitedSet = HashSet.from(user.visited);
    user.increaseLevel();
    if (!visitedSet.contains(place.getPositionStr())) {
      user.visited.add(place.getPositionStr());

      //user.level.increaseLevel();
    }
    FirestoreService.updateUser(user);
  }

  bool hasVisited(Place place) {
    User user = Globals.instance.user;
    return user.visited.contains(place.getPositionStr());
  }

  LatLng _toLatLng(Position p) {
    return LatLng(p.latitude, p.longitude);
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream.cancel();
      positionStream = null;
    }
    super.dispose();
  }
}

enum Size { big, small }
