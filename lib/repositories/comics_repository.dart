import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comics.dart';

class ComicsRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Comics>> fetchComics({int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/issues?api_key=$_apiKey&format=json&limit=$limit&offset=10&field_list=id,image,name,volume,issue_number,cover_date,api_detail_url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Comics.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comics');
    }
  }

  Future<List<Comics>> searchComics(String query) async {
    final url = Uri.parse('$_baseUrl/search?api_key=$_apiKey&format=json&resources=issue&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Comics.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search comics');
    }
  }
}
