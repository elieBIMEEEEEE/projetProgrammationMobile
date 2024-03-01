import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Movie>> fetchMovies({int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/movies?api_key=$_apiKey&format=json&limit=$limit&offset=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assurez-vous d'ajouter des vérifications pour s'assurer que 'results' n'est pas null
      if (data['results'] != null) {
        final results = List<Map<String, dynamic>>.from(data['results']);
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        // Retourne une liste vide si 'results' est null pour éviter des erreurs
        return [];
      }
    } else {
      throw Exception('Failed to load movies. Status code: ${response.statusCode}');
    }
  }
}
