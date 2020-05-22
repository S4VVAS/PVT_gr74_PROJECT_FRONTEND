import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:history_go/src/services/custom_exception.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String _baseUrl = 'https://group4-75.pvt.dsv.su.se/';

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while communication with server with statusCode : ${response.statusCode}');
    }
  }
}
