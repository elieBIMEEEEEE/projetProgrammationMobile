import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<Movie> fetchMovie({required String id}) async {
    final url = Uri.parse('$_baseUrl/movie/4025-$id?api_key=$_apiKey&format=json');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data['results']);
    } else {
      throw Exception('Failed to load movie. Status code: ${response.statusCode}');
    }
  }
}

