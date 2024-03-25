import 'package:projet/models/episode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EpisodeRepository{
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Episode>> fetchEpisodes({required String seriesId}) async {
    final url = Uri.parse('https://comicvine.gamespot.com/api/episodes/?api_key=$_apiKey&format=json&filter=series:$seriesId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final episodes = data['results'] as List<dynamic>;
      return episodes.map((e) => Episode.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load episodes. Status code: ${response.statusCode}');
    }
  }
}