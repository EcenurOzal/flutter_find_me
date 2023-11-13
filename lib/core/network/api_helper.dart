import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../exception/network_exception.dart';

enum HttpMethod { get, post, put, delete }

class ApiHelper {
  Future<(NetworkException?, http.Response?)> request({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    final fullUrl = Uri.parse(url);

    //? Log
    log(" **** Url  *** ");
    log(fullUrl.toString());

    try {
      http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await http.get(
            fullUrl.replace(queryParameters: queryParameters),
          );
          break;
        case HttpMethod.post:
          response = await http.post(
            fullUrl,
            body: jsonEncode(data),
            headers: {"Content-Type": "application/json"},
          );
          break;
        case HttpMethod.put:
          response = await http.put(
            fullUrl,
            body: jsonEncode(data),
            headers: {"Content-Type": "application/json"},
          );
          break;
        case HttpMethod.delete:
          response = await http.delete(
            fullUrl,
            body: jsonEncode(data),
            headers: {"Content-Type": "application/json"},
          );
          break;
      }

      //? Log
      log(" **** Response  *** ");
      log(response.body);
      log(" **** end of Response  *** ");

      if (response.statusCode != 200) {
        return (
          NetworkException('HTTP Error: ${response.statusCode}', null),
          null
        );
      } else {
        return (null, response);
      }
    } catch (e) {
      return (NetworkException('$e', null), null);
    }
  }
}
