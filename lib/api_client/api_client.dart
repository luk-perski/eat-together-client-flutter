import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/api_utils.dart' as apiUtils;

class ApiClient {
  Future<http.Response> post(Map data, String serviceName) async {
    return await http
        .post(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            body: json.encode(data), headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> patch(Map data, String serviceName) async {
    return await http
        .patch(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            body: json.encode(data), headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> get(String serviceName) async {
    final response = await http
        .get(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != HttpStatus.ok) {
      print(response.body);
    }
    return response;
  }

  Future<List> getList(String serviceName) async {
    final response = await http
        .get(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return json.decode(apiUtils.getUtf8Body(response));
    }
    throw Exception('Failed to load jobs from API');
  }

  Future<http.Response> put(String serviceName, [Map data]) async {
    return await http
        .put(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            body: data != null ? json.encode(data) : null,
            headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
  }

  Future<http.Response> delete(String serviceName) async {
    return await http
        .delete(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
  }
}
