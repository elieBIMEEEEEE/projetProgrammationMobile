import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import 'common_method.dart';

class CharacterRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Character>> fetchCharacters({int limit = 10, int offset = 0}) async {
    final url = Uri.parse('$_baseUrl/characters?api_key=$_apiKey&format=json&limit=$limit&offset=$offset&field_list=id,name,api_detail_url');
    return await _performRequest(url);
  }

  Future<List<Character>> fetchCharactersImage(List<Character> characters) async {
    int sublistEndIndex = characters.length > 10 ? 10 : characters.length;
    List<Future<Character>> characterFutures = characters.sublist(0, sublistEndIndex).map((character) async {
      final url = Uri.parse('${character.apiDetailUrl}?api_key=$_apiKey&format=json&field_list=image');
      return await _performRequestForSingleCharacterImage(url, character);
    }).toList();

    return Future.wait(characterFutures);
  }

  Future<Character> fetchCharacterDetails(Character character) async {
    final url = Uri.parse('${character.apiDetailUrl}?api_key=$_apiKey&format=json&field_list=description,real_name,aliases,publisher,creators,gender,birth');
    return await _performRequestForSingleCharacterDetails(url, character);
  }

  Future<List<Character>> searchCharacters(String query) async {
    final url = Uri.parse('$_baseUrl/search?api_key=$_apiKey&format=json&resources=character&query=$query&field_list=id,name,image,api_detail_url');
    return await _performRequestSearch(url);
  }

  Future<List<Character>> _performRequest(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      return handleError(response.statusCode);
    }
  }

  Future<List<Character>> _performRequestSearch(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Character.fromSearchJson(json)).toList();
    } else {
      return handleError(response.statusCode);
    }
  }

  Future<Character> _performRequestForSingleCharacterImage(Uri url, Character characterToUpdate) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      characterToUpdate.updateFromJson(data['results']);
      return characterToUpdate;
    } else {
      return Future.error(handleError(response.statusCode));
    }
  }

  Future<Character> _performRequestForSingleCharacterDetails(Uri url, Character characterToUpdate) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      characterToUpdate.updateDetailsFromJson(data['results']);
      return characterToUpdate;
    } else {
      return Future.error(handleError(response.statusCode));
    }
  }

}
