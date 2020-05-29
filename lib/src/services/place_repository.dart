import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:history_go/src/services/api_provider.dart';
import 'package:history_go/src/models/place.dart';

class PlaceRepository {
  ApiProvider _provider = ApiProvider();

  Future<Set<Place>> getPlaces(LatLng userPosition) async {
    String _url =
        'getPlaces?lat=${userPosition.latitude}&lon=${userPosition.longitude}';
    return _toApi(_url);
  }

  Future<Set<Place>> getBoundedPlaces(LatLngBounds bounds) async {
    String _url =
        'getBoundedPlaces?swLat=${bounds.southwest.latitude}&swLon=${bounds.southwest.longitude}' +
            '&neLat=${bounds.northeast.latitude}&neLon=${bounds.northeast.longitude}';
    return _toApi(_url);
  }

  Future<Set<Place>> getPlacesFromCoords(List<String> coords) {
    String _url = 'getCoorPlaces?coors=';
    for (int i = 0; i < coords.length; i++) {
      print(coords[i]);
      _url += '${coords[i]}' + (i < coords.length - 1 ? ',' : '');
    }
    return _toApi(_url);
  }

  Future<Set<Place>> _toApi(String _url) async {
    debugPrint('REQUEST TO API: ' + _url);
    final _response = await _provider.get(_url);
    HashSet<Place> places = new HashSet();
    for (var place in _response) {
      places.add(Place.fromJson(place));
    }
    debugPrint("getBoundedPlaces returned ${places.length} places");

    return places;
  }
}
