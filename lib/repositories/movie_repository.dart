import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'common_method.dart';

class MovieRepository {
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<Movie> fetchMovie({required String apiUrl}) async {
    final url = Uri.parse('$apiUrl?api_key=$_apiKey&format=json&field_list=id,name,image,producers,release_date,runtime,total_revenue,writers,box_office_revenue,budget,characters,studios,description,rating,api_detail_url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data['results']);
    } else {
      return handleError(response.statusCode);
    }
  }
}
