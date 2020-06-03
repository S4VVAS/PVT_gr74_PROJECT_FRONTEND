import 'dart:collection';

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

  Future<HashSet<Place>> getPlacesFromCoords(List coords) async {
    String _url = 'getCoorPlaces?coors=';
    for (int i = 0; i < coords.length; i++) {
      _url += '${coords.elementAt(i)}' + (i < coords.length - 1 ? ',' : '');
    }
    return _toApi(_url);
  }

  Future<HashSet<Place>> _toApi(String _url) async {
    HashSet<Place> places = new HashSet();
    debugPrint('REQUEST TO API: ' + _url);
    try {
      final _response = await _provider.get(_url);
      for (var place in _response) {
        places.add(Place.fromJson(place));
      }
      debugPrint("getBoundedPlaces returned ${places.length} places");
    } catch (e) {
      print(e);
    }

    return places;
  }
}
