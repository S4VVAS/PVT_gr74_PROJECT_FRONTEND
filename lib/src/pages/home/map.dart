import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history_go/src/models/place.dart';
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
  GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  List<Place> places = new List<Place>();
  int _markerIdCounter = 1;
  MarkerId selectedMarker;

  static LatLng _userPosition;
  static LatLng _lastCall;

  double placeSeenColor = BitmapDescriptor.hueYellow;
  double placeNotSeenColor = BitmapDescriptor.hueGreen;

  Geolocator _geolocator = Geolocator();

  double _zoom = 17.0;

  @override
  void initState() {
    super.initState();
    _lastCall = new LatLng(0, 0);
    _geolocator.getPositionStream(
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) async {
          //zoom = await _controller.getZoomLevel();
          _userPosition = _toLatLng(position);
          //_controller?.getVisibleRegion()?.then((value) => print(value.toString()));
          updatePlaces();
          _controller?.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _userPosition, zoom: await _controller.getZoomLevel() )));
    });
  }

  Future<void> updatePlaces() async {
      double distance = await Geolocator().distanceBetween(
          _lastCall.latitude, _lastCall.longitude,
          _userPosition.latitude, _userPosition.longitude
      );
      print(distance);
    if (distance > 100) {
      _lastCall = _userPosition;
      List<Place> _updatedPlaces = await PlaceRepository().getPlaces(
          _userPosition);
      print(this.toDiagnosticsNode().toString() + " \nis mounted:" + this.mounted.toString());
      if (this.mounted) {
        setState(() {
          places = _updatedPlaces;
          setMarkers();
        });
      }
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
                        _controller = controller;
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

    bool visited = await hasVisited(place.position);
    double iconColor = visited ? placeSeenColor : placeNotSeenColor;

    final Marker marker = Marker(
        markerId: markerId,
        position: place.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(iconColor),
        consumeTapEvents: true,
        onTap: () {
            _onMarkerTapped(markerId);
            saveAsVisited(place.position);
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
  void saveAsVisited(LatLng position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Value används ej, därav -> "".
    await prefs.setString(position.toString(), "");
  }

  Future<bool> hasVisited(LatLng position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool visited = prefs.containsKey(position.toString());
    return Future<bool>.value(visited);
  }

  LatLng _toLatLng(Position p) {
    return LatLng(p.latitude, p.longitude);
  }

}
