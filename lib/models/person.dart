class Person{
  late String id;
  late String name;
  late String imageUrl;
  late String apiDetailUrl;
  late String country;

  Person({required this.id, required this.name, required this.apiDetailUrl});

  factory Person.fromJson(Map<String, dynamic> json) {
    String id = json['id']?.toString() ?? '0000';
    String name = json['name']?.toString() ?? 'Unknown';
    String apiDetailUrl = json['api_detail_url']?.toString() ?? '';

    return Person(
      id: id,
      name: name,
      apiDetailUrl: apiDetailUrl,
    );
  }

  void updateFromJson(Map<String, dynamic> json) {
    imageUrl = json['image'] != null ? json['image']['original_url'] ?? 'path/to/image' : 'path/to/image';
    country = json['country']?.toString() ?? 'Unknown';
  }
}