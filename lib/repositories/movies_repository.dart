import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies.dart';

class MoviesRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Movies>> fetchMovies({int limit = 10}) async {
    final url = Uri.parse(
        '$_baseUrl/movies?api_key=$_apiKey&format=json&limit=$limit&offset=10&field_list=id,image,name,release_date,runtime,api_detail_url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Movies.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load movies. Status code: ${response.statusCode}');
    }
  }

  Future<List<Movies>> searchMovies(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search?api_key=$_apiKey&format=json&resources=movie&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Movies.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
