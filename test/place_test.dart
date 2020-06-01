import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:history_go/src/models/place.dart';

void main() {
  test('hashcode', () async {
    Entries entries1 = new Entries(date: "2020-06-01", img: "test.com", desc: "test", name: "testNamn1", title: "testTitle1");

    Place place1 = new Place(entries: [entries1] , position: new LatLng(10, 10));
    Place place2 = new Place(entries: [entries1] , position: new LatLng(10, 10));

    HashSet<Place> places = new HashSet();
    
    places.add(place1);

    expect(places.contains(place2), true);
  });
}