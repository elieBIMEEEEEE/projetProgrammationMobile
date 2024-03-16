import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class CharacterRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey =
      '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Character>> fetchCharacters(
      {int limit = 10, int offset = 0}) async {
    final url = Uri.parse(
        '$_baseUrl/characters?api_key=$_apiKey&format=json&limit=$limit&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<List<Character>> searchCharacters(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search?api_key=$_apiKey&format=json&resources=character&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search characters');
    }
  }
}
