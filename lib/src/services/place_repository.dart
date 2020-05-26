import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:history_go/src/services/api_provider.dart';
import 'package:history_go/src/models/place.dart';

class PlaceRepository {
  ApiProvider _provider = ApiProvider();

  Future<List<Place>> getPlaces(LatLng userPosition) async {
    String _posUrl =
        'getPlaces?lat=${userPosition.latitude}&lon=${userPosition.longitude}';
    debugPrint("REQUEST TO API: " + _posUrl);
    final _response = await _provider.get(_posUrl);
    List<Place> places = new List();
    for (var place in _response) {
      places.add(Place.fromJson(place));
    }
    debugPrint("getPlaces returned ${places.length} places");

    return places;
  }

  Future<List<Place>> getBoundedPlaces(LatLngBounds bounds) async {
    String _url =
        'getBoundedPlaces?swLat=${bounds.southwest.latitude}&swLon=${bounds.southwest.longitude}' +
            '&neLat=${bounds.northeast.latitude}&neLon=${bounds.northeast.longitude}';
    debugPrint('REQUEST TO API: ' + _url);
    final _response = await _provider.get(_url);
    List<Place> places = new List();
    for (var place in _response) {
      places.add(Place.fromJson(place));
    }
    debugPrint("getBoundedPlaces returned ${places.length} places");

    return places;
  }
}
