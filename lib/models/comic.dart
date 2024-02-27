class Comic {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int issueNumber;

  Comic({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    required this.issueNumber,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'].toString(),
      name: json['name'] ?? 'Name not available',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'default_image_url',
      issueNumber: json['issue_number'] != null ? int.parse(json['issue_number']) : 0,
    );
  }
}
