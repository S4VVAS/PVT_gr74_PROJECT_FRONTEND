import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';
import 'package:history_go/src/services/place_repository.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;*/

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _completer = new Completer();
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final FirestoreService _firestoreService = FirestoreService();

  List<Place> places = new List<Place>();
  int _markerIdCounter = 1;
  MarkerId selectedMarker;

  static LatLng _userPosition;
  static LatLng _lastCall;

  double placeSeenColor = BitmapDescriptor.hueYellow;
  double placeNotSeenColor = BitmapDescriptor.hueGreen;

  StreamSubscription positionStream;
  Geolocator _geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  double _zoom = 17.0;

  @override
  void initState() {
    super.initState();
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
    shouldUpdatePlaces().then((result) async {
      if (result) {
        print("updating places");
        await _completer.future.then((controller) => _controller = controller);

        if (_completer.isCompleted) {
          _controller.getVisibleRegion().then(((bounds) async {
            print(bounds.toString());
            await PlaceRepository()
                .getBoundedPlaces(bounds)
                .then((updated) => updatePlaces(updated));
          }));
        }
      }
    });
    _controller?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _userPosition, zoom: await _controller.getZoomLevel())));
  }

  Future<bool> shouldUpdatePlaces() async {
    if (_lastCall == null) {
      print("first");
      _lastCall = _userPosition;
      return true;
    }
    if (_lastCall == _userPosition) return false;

    double distance = await _geolocator.distanceBetween(_lastCall.latitude,
        _lastCall.longitude, _userPosition.latitude, _userPosition.longitude);
    print(distance);

    return distance > 100;
  }

  void updatePlaces(List updated) {
    _lastCall = _userPosition;
    print(this.toDiagnosticsNode().toString() +
        " \nis mounted:" +
        this.mounted.toString());
    if (this.mounted) {
      setState(() {
        places = updated;
        setMarkers();
      });
    }
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
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _completer.complete(controller);
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: _userPosition,
                      zoom: _zoom,
                      //tilt: CAMERA_TILT,
                      //bearing: CAMERA_BEARING,
                    ),
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(8.0) + MediaQuery.of(context).padding,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: <Widget>[
                          MapSettingsButton(),
                        ],
                      ),
                    ),
                  ),
                ],
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

  void addMarker(Place place) async {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    bool visited = await hasVisited(place);
    double iconColor = visited ? placeSeenColor : placeNotSeenColor;

    final Marker marker = Marker(
        markerId: markerId,
        position: place.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(iconColor),
        consumeTapEvents: true,
        onTap: () {
            _onMarkerTapped(markerId);
            saveAsVisited(place);
            Navigator.pushNamed(context, "/info", arguments: place);
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

  //TODO: saveAsVisited och hasVisited bör nog dels ligga i annan klass (user?)
  // och dels köras vid appstart eller  inloggning.
  // Kanske går att använda userID från firebase-usern på något sätt så det blir
  // unikt för användaren ist för devicen?
  void saveAsVisited(Place place) async {
    User user = Globals.instance.user;
    user.visited.add(place);
    _firestoreService.updateUser(user);
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    // Value används ej, därav -> "".
    await prefs.setString(position.toString(), "");*/
  }

  Future<bool> hasVisited(Place place) async {
    User user = Globals.instance.user;
    User tmpUser = await _firestoreService.getUser(user.id);
    if(tmpUser == null){
      print('TmpUser is NULL');
    }
    else {
      List<Place> places = tmpUser.visited;
      bool visited = places.contains(place);
      Globals.instance.user = tmpUser;
      return visited;
    }
    return false;
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool visited = prefs.containsKey(position.toString());
    return Future<bool>.value(visited);*/
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
