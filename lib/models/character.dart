class Character {
  final String id;
  final String imageUrl;
  final String name;

  Character({
    required this.id,
    required this.imageUrl,
    required this.name,  });

  factory Character.fromJson(Map<String, dynamic> json) {
    String defaultImageUrl = 'https://www.placecage.com/200/300';
    String id = json['id']?.toString() ?? '0000';
    String name = json['name']?.toString() ?? 'Unknown';
    String imageUrl = json['image'] != null ? json['image']['original_url'] ?? defaultImageUrl : defaultImageUrl;

    return Character(
      id: id,
      imageUrl: imageUrl,
      name: name,
    );
  }
}
