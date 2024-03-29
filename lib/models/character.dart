import 'package:projet/models/person.dart';

class Character {
  late final String id;
  late final String imageUrl;
  late final String name;
  late final String apiDetailUrl;
  late final String description;
  late final String realName;
  late final List<String> aliases;
  late final String publisher;
  late final List<Person> creators;
  late final String gender;
  late final String birth;

  Character({
    required this.id,
    required this.name,
    required this.apiDetailUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    String id = json['id']?.toString() ?? '0000';
    String name = json['name']?.toString() ?? 'Unknown';
    String apiDetailUrl = json['api_detail_url']?.toString() ?? 'Unknown';

    return Character(
      id: id,
      name: name,
      apiDetailUrl: apiDetailUrl,
    );
  }

  factory Character.fromSearchJson(Map<String, dynamic> json) {
    String id = json['id']?.toString() ?? '0000';
    String name = json['name']?.toString() ?? 'Unknown';
    String imageUrl = json['image'] != null ? json['image']['original_url'] ?? 'path/to/image' : 'path/to/image';
    String apiDetailUrl = json['api_detail_url']?.toString() ?? 'Unknown';

    Character character = Character(
      id: id,
      name: name,
      apiDetailUrl: apiDetailUrl,
    );
    character.imageUrl = imageUrl;

    return character;
  }

  void updateFromJson(Map<String, dynamic> json) {
    imageUrl = json['image'] != null ? json['image']['original_url'] ?? 'path/to/image' : 'path/to/image';
  }

  void updateDetailsFromJson(Map<String, dynamic> json) {
    String description = json['description']?.toString() ?? 'No description available';
    String realName = json['real_name']?.toString() ?? 'Unknown';
    String aliasesString = json['aliases']?.toString() ?? '';
    List<String> aliases = aliasesString.split('\n').where((alias) => alias.isNotEmpty).toList();
    String publisher = json['publisher'] != null ? json['publisher']['name']?.toString() ?? 'Unknown' : 'Unknown';
    List<dynamic> creatorsList = json['creators'] ?? [];
    List<Person> creators = creatorsList.map((creator) => Person.fromJson(creator)).toList();
    String gender = json['gender']?.toString() ?? 'Unknown';
    String birth = json['birth']?.toString() ?? 'Unknown';

    this.description = description;
    this.realName = realName;
    this.aliases = aliases;
    this.publisher = publisher;
    this.creators = creators;
    this.gender = gender;
    this.birth = birth;
  }


}
