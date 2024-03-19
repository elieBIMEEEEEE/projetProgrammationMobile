class Character {
  late final String id;
  late final String imageUrl;
  late final String name;
  late final String apiDetailUrl;

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

  void updateFromJson(Map<String, dynamic> json) {
    imageUrl = json['image'] != null ? json['image']['original_url'] ?? 'path/to/image' : 'path/to/image';
  }
}
