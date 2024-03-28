import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/series.dart';

class SeriesRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Series>> fetchSeries({int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/series_list?api_key=$_apiKey&format=json&limit=$limit&offset=10&field_list=name,api_detail_url,image,deck,description');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load series');
    }
  }

  Future<List<Series>> searchSeries(String query) async {
    final url = Uri.parse('$_baseUrl/search?api_key=$_apiKey&format=json&resources=series&query=$query&field_list=name,api_detail_url,image,deck,description');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search series');
    }
  }
}
