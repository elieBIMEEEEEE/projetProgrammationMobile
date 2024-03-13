class Series {
  final String id;
  final String name;
  final String? deck; // Nullable, car peut ne pas être présent
  final String? description; // Nullable, car peut ne pas être présent
  final String imageUrl;
  final int countOfEpisodes;
  final String publisher;
  final String startYear; // Considérer un int ou DateTime si applicable
  final String? aliases; // Nullable, car peut ne pas être présent
  final String apiDetailUrl;
  final DateTime dateAdded; // Utiliser DateTime pour une gestion plus aisée des dates
  final DateTime dateLastUpdated; // Utiliser DateTime
  final String siteDetailUrl;

  Series({
    required this.id,
    required this.name,
    this.deck,
    this.description,
    required this.imageUrl,
    required this.countOfEpisodes,
    required this.publisher,
    required this.startYear,
    this.aliases,
    required this.apiDetailUrl,
    required this.dateAdded,
    required this.dateLastUpdated,
    required this.siteDetailUrl,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'].toString(),
      name: json['name'] ?? 'Name not available',
      deck: json['deck'],
      description: json['description'],
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'default_image_url',
      countOfEpisodes: json['count_of_episodes'] as int? ?? 0,
      publisher: json['publisher'] != null ? json['publisher']['name'] : 'Publisher not available',
      startYear: json['start_year']?.toString() ?? 'Year not available',
      aliases: json['aliases']?.replaceAll('\n', ', '),
      apiDetailUrl: json['api_detail_url'] ?? '',
      dateAdded: DateTime.parse(json['date_added'] ?? DateTime.now().toIso8601String()),
      dateLastUpdated: DateTime.parse(json['date_last_updated'] ?? DateTime.now().toIso8601String()),
      siteDetailUrl: json['site_detail_url'] ?? '',
    );
  }
}
