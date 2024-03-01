import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/series.dart';

class SeriesRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Series>> fetchSeries({int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/series_list?api_key=$_apiKey&format=json&limit=$limit&offset=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load series');
    }
  }
}
