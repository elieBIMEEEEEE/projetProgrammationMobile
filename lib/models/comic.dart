class Comic {
  final String id;
  final String imageUrl;
  final String name;
  final Map<String, dynamic> volume;
  final String issueNumber;
  final String coverDate;

  Comic({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.volume,
    required this.issueNumber,
    required this.coverDate,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    String defaultImageUrl = 'https://www.placecage.com/200/300';
    String id = json['id']?.toString() ?? '0000';
    String name = json['name']?.toString() ?? 'Unknown';
    String imageUrl = json['image'] != null ? json['image']['original_url'] ?? defaultImageUrl : defaultImageUrl;
    Map<String, dynamic> volume = json['volume'] ?? {};
    String issueNumber = json['issue_number']?.toString() ?? 'Unknown';
    String coverDate = json['cover_date']?.toString() ?? 'Unknown';

    return Comic(
      id: id,
      imageUrl: imageUrl,
      name: name,
      volume: volume,
      issueNumber: issueNumber,
      coverDate: coverDate,
    );
  }
}
