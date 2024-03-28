import '../models/person.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonRepository {
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';


  Future<List<Person>> fetchPersons({int limit = 10, int offset = 0}) async {
    final url = Uri.parse(
        'https://comicvine.gamespot.com/api/people?api_key=$_apiKey&format=json&limit=$limit&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load persons');
    }
  }

Future<List<Person>> fetchPersonsDetails(List<Person> persons) async {
    final List<Future<Person>> futures = persons.map((person) async {
      final url = Uri.parse(
          '${person.apiDetailUrl}?api_key=$_apiKey&format=json&field_list=image');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        person.updateFromJson(data['results']);
        return person;
      } else {
        throw Exception('Failed to load person details');
      }
    }).toList();

    return Future.wait(futures);
  }

  Future<List<Person>> searchPersons(String query) async {
    final url = Uri.parse(
        'https://comicvine.gamespot.com/api/search?api_key=$_apiKey&format=json&resources=person&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Person.fromSearchJson(json)).toList();
    } else {
      throw Exception('Failed to search persons');
    }
  }
}