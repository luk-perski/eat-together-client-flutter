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

  Future<List> get(String serviceName) async {
    final response = await http
        .get(apiUtils.urlBase + apiUtils.serverApi + serviceName,
            headers: await apiUtils.getHeaders())
        .timeout(const Duration(seconds: 10));
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load jobs from API');
  }
}
