import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/services/place_repository.dart';
import 'package:history_go/src/components/buttons.dart';

/*const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;*/

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = new Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  List<Place> places = new List<Place>();
  int _markerIdCounter = 1;
  MarkerId selectedMarker;

  static LatLng _userPosition;

  @override
  void initState() {
    super.initState();
    _getUserPosition().whenComplete(() => updatePlaces());
  }

    Future<void> updatePlaces() async {
    List<Place> _updatedPlaces = await PlaceRepository().getPlaces(_userPosition);
    if (this.mounted) {
      setState(() {
        places = _updatedPlaces;
        setMarkers();
      });
    }
  }

  Future<LatLng> _getUserPosition() async {
    debugPrint("User position requested");
    Position position = await Geolocator().getCurrentPosition().whenComplete(() => debugPrint("User position acquired"));

    if (this.mounted) {
      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
        debugPrint('User position: ${_userPosition.toString()}');
      });
    }

    return _userPosition;
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
                        _controller.complete(controller);
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: _userPosition,
                      zoom: 14.4,
                      //tilt: CAMERA_TILT,
                      //bearing: CAMERA_BEARING,
                    ),
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    onCameraIdle: _onCameraIdle,
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

  void _onMarkerTapped(MarkerId markerId, Place place) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker].copyWith(
              iconParam: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen));
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
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

    final Marker marker = Marker(
        markerId: markerId,
        position: place.position,
        infoWindow: InfoWindow(
            //TODO: ska infowindow visa titel och beskrivning för första entryn i platsen??
            title: place.entries[0].title,
            snippet: place.entries[0].desc ?? 'saknar beskrivning',
            onTap: () =>
                Navigator.pushNamed(context, "/info", arguments: place)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () {
          _onMarkerTapped(markerId, place);
        });
    setState(() {
      markers[markerId] = marker;
    });
  }

  void setMarkers() {
    debugPrint("Setting markers");
    for (Place p in places) {
      addMarker(p);
    }
  }

  void _onCameraIdle() {
    //updatePlaces();
    print('idling...');
  }
}
