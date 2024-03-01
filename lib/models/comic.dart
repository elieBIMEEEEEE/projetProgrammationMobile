class Comic {
  final String id;
  final String name;
  final String aliases;
  final String apiDetailUrl;
  final String coverDate;
  final String dateAdded;
  final String dateLastUpdated;
  final String deck;
  final String description;
  final bool hasStaffReview;
  final String issueNumber;
  final String imageUrl;
  final String siteDetailUrl;
  final String storeDate;
  final Map<String, dynamic> volume;

  Comic({
    required this.id,
    required this.name,
    required this.aliases,
    required this.apiDetailUrl,
    required this.coverDate,
    required this.dateAdded,
    required this.dateLastUpdated,
    required this.deck,
    required this.description,
    required this.hasStaffReview,
    required this.issueNumber,
    required this.imageUrl,
    required this.siteDetailUrl,
    required this.storeDate,
    required this.volume,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? 'Unknown',
      aliases: json['aliases'] ?? '',
      apiDetailUrl: json['api_detail_url'] ?? '',
      coverDate: json['cover_date'] ?? '',
      dateAdded: json['date_added'] ?? '',
      dateLastUpdated: json['date_last_updated'] ?? '',
      deck: json['deck'] ?? '',
      description: json['description'] ?? '',
      hasStaffReview: json['has_staff_review'] ?? false,
      issueNumber: json['issue_number']?.toString() ?? '0',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'path/to/default/image.png',
      siteDetailUrl: json['site_detail_url'] ?? '',
      storeDate: json['store_date'] ?? '',
      volume: json['volume'] ?? {},
    );
  }
}
