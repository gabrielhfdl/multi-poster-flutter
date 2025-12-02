import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

abstract class IApiDataSource {
  Future<Map<String, dynamic>> scrapeProduct(String url);
  Future<Map<String, dynamic>> postEverywhere(Map<String, dynamic> body);
}

class ApiDataSource implements IApiDataSource {
  @override
  Future<Map<String, dynamic>> scrapeProduct(String url) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.scrapeProductEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'url': url}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao fazer scraping');
      }
    } catch (e) {
      throw Exception('Erro ao fazer scraping: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> postEverywhere(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.postEverywhereEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao enviar');
      }
    } catch (e) {
      throw Exception('Erro ao enviar: ${e.toString()}');
    }
  }
}
