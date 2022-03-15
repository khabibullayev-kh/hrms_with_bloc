import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

Future<Map<String, String>> buildHeaderTokens() async {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    HttpHeaders.authorizationHeader:
        'Bearer ${await SessionDataProvider().getToken()}',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };
  return header;
}

Uri buildBaseUrl(String endPoint) {
  final mBaseUrl = dotenv.env['MAIN_URL'];
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');

  return url;
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET, Map? request}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);
    print(url.query);
    try {
      Response response;

      if (method == HttpMethod.POST) {
        response =
            await http.post(url, headers: await headers, body: request);
      } else if (method == HttpMethod.DELETE) {
        response = await delete(url, headers: await headers);
      } else if (method == HttpMethod.PUT) {
        response = await put(url, body: jsonEncode(request), headers:await headers);
      } else if (method == HttpMethod.PATCH) {
        response = await patch(url, headers: await headers, body: request);
      }else {
        response = await get(url, headers:await headers);


      }
      return response;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode.isSuccessful()) {

    return jsonDecode(response.body);
  } else {
      _validateResponse(response);
  }
}

void _validateResponse(Response response) {
  if (response.statusCode == 500) {
    print(response.body);
    print(response.request);
    throw ApiClientException(ApiClientExceptionType.sessionExpired);
    // final dynamic status = json['status_code'];
    // final code = status is int ? status : 0;
    // if (code == 30) {
    //   throw ApiClientException(ApiClientExceptionType.auth);
    // } else if (code == 3) {
    //   throw ApiClientException(ApiClientExceptionType.sessionExpired);
    // } else {
    //   throw ApiClientException(ApiClientExceptionType.other);
    // }
  }
}

enum HttpMethod { GET, POST, DELETE, PUT, PATCH }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  @override
  String toString() => "FormatException: $message";
}
