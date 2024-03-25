import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet/models/serie.dart';
import 'episode_repository.dart';

class SerieRepository {
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<Serie> fetchSerie({required String apiDetailUrl}) async {
    final url = Uri.parse('$apiDetailUrl?api_key=$_apiKey&format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final serie = Serie.fromJson(data['results']);
      final episodes = await EpisodeRepository().fetchEpisodes(seriesId: serie.id);
      serie.setEpisodes(episodes);
      return serie;
    } else {
      throw Exception('Failed to load serie. Status code: ${response.statusCode}');
    }
  }
}