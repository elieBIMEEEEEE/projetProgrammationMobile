import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import 'common_method.dart';

class PersonRepository {
  final String _baseUrl = 'https://comicvine.gamespot.com/api';
  final String _apiKey = '6db50ee6d46842bad12ce3ecbf244c7aae2f9041';

  Future<List<Person>> fetchPersons({int limit = 10, int offset = 0}) async {
    final url = Uri.parse('$_baseUrl/people?api_key=$_apiKey&format=json&limit=$limit&offset=$offset&field_list=id,name,image,api_detail_url');
    return await _performRequest(url);
  }

  Future<List<Person>> fetchPersonsDetails(List<Person> persons) async {
    int sublistEndIndex = persons.length > 10 ? 10 : persons.length; // Détermine la fin de la sous-liste basée sur la condition
    List<Future<Person>> personFutures = persons.sublist(0, sublistEndIndex).map((person) async {
      final url = Uri.parse('${person.apiDetailUrl}?api_key=$_apiKey&format=json&field_list=image');
      return await _performRequestForSinglePerson(url, person);
    }).toList();

    return Future.wait(personFutures);
  }

  Future<List<Person>> searchPersons(String query) async {
    final url = Uri.parse('$_baseUrl/search?api_key=$_apiKey&format=json&resources=person&query=$query&field_list=id,name,image,api_detail_url');
    return await _performRequest(url);
  }

  Future<List<Person>> _performRequest(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = List<Map<String, dynamic>>.from(data['results']);
      return results.map((json) => Person.fromJson(json)).toList();
    } else {
      return handleError(response.statusCode);
    }
  }

  Future<Person> _performRequestForSinglePerson(Uri url, Person personToUpdate) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      personToUpdate.updateFromJson(data['results']);
      return personToUpdate;
    } else {
      return Future.error(handleError(response.statusCode));
    }
  }
}
