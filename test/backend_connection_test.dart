import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Backend Connection', ()
  {
    test('getPlaces', () async {
      var url = 'https://group4-75.pvt.dsv.su.se/getPlaces?lat=59.335&lon=18.091';
      var response = await http.get(url);
      print('Response status for getPlaces: ${response.statusCode}');
      expect(response.statusCode, 200);
    });

    test('getBoundedPlaces', () async {
      var url = 'https://group4-75.pvt.dsv.su.se/getBoundedPlaces?swLat=59.327236192201994&swLon=18.066459707915783&neLat=59.33119697926541&neLon=18.070873618125916';
      var response = await http.get(url);
      print('Response status for getBoundedPlaces: ${response.statusCode}');
      expect(response.statusCode, 200);
    });

    test('getCoorPlaces', () async {
      var url = 'https://group4-75.pvt.dsv.su.se/getCoorPlaces?coors=59.3293678848816%2018.0687667553766,59.3276747180171%2018.0685436339484';
      var response = await http.get(url);
      print('Response status for getCoorPlaces: ${response.statusCode}');
      expect(response.statusCode, 200);
    });
  });
}
