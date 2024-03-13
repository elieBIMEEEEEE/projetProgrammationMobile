class Comic {
  final String id;
  final String name;
  final String? aliases; // Nullable si 'aliases' peut être absent ou null
  final String apiDetailUrl;
  final DateTime? coverDate; // Utiliser DateTime si possible pour une date
  final DateTime dateAdded;
  final DateTime dateLastUpdated;
  final String? deck; // Nullable si 'deck' peut être absent ou null
  final String? description; // Nullable si 'description' peut être absent ou null
  final bool hasStaffReview;
  final String issueNumber;
  final String imageUrl;
  final String siteDetailUrl;
  final DateTime? storeDate; // Utiliser DateTime si possible pour une date
  final Map<String, dynamic> volume; // Assumer que la structure reste en Map

  Comic({
    required this.id,
    required this.name,
    this.aliases,
    required this.apiDetailUrl,
    this.coverDate,
    required this.dateAdded,
    required this.dateLastUpdated,
    this.deck,
    this.description,
    required this.hasStaffReview,
    required this.issueNumber,
    required this.imageUrl,
    required this.siteDetailUrl,
    this.storeDate,
    required this.volume,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? 'Unknown',
      aliases: json['aliases'],
      apiDetailUrl: json['api_detail_url'] ?? '',
      coverDate: json['cover_date'] != null ? DateTime.tryParse(json['cover_date']) : null,
      dateAdded: DateTime.parse(json['date_added'] ?? DateTime.now().toIso8601String()),
      dateLastUpdated: DateTime.parse(json['date_last_updated'] ?? DateTime.now().toIso8601String()),
      deck: json['deck'],
      description: json['description'],
      hasStaffReview: json['has_staff_review'] ?? false,
      issueNumber: json['issue_number']?.toString() ?? '0',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'path/to/default/image.png',
      siteDetailUrl: json['site_detail_url'] ?? '',
      storeDate: json['store_date'] != null ? DateTime.tryParse(json['store_date']) : null,
      volume: json['volume'] ?? <String, dynamic>{},
    );
  }
}
