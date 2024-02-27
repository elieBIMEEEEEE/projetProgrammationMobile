class Character {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'].toString(),
      name: json['name'] ?? 'Name not available',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'default_image_url',
    );
  }
}
