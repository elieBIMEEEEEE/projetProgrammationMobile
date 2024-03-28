import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comic.dart';
import 'common_method.dart';

class ComicRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<Comic> fetchComic({required String apiDetailUrl}) async {
    final url = Uri.parse('$apiDetailUrl?api_key=$_apiKey&format=json&field_list=id,image,name,volume,issue_number,cover_date,character_credits,person_credits,api_detail_url,description');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Comic.fromJson(data['results']);
    } else {
      return handleError(response.statusCode);
    }
  }

  Future<List<Comic>> searchComics(String query) async {
    final url = Uri.parse('$_baseUrl/search?api_key=$_apiKey&format=json&resources=issue&query=$query&field_list=id,image,name,volume,issue_number,cover_date,character_credits,person_credits,api_detail_url,description');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Comic.fromJson(json)).toList();
    } else {
      return handleError(response.statusCode);
    }
  }
}
