class Movie {
  final int id;
  final String imageUrl;
  final String name;
  final List<String> producers; // Change to List<String> if multiple producers
  final String rating;
  final DateTime releaseDate; // Use DateTime for dates
  final int runtime; // runtime likely to be in minutes, so int is more appropriate
  final String siteDetailUrl;
  final List<String> studios; // Change to List<String> if multiple studios
  final int totalRevenue; // Use int for monetary values
  final List<String> writers; // Change to List<String> if multiple writers
  final String apiDetailUrl;
  final int boxOfficeRevenue; // Use int for monetary values
  final int budget; // Use int for monetary values
  final DateTime dateAdded; // Use DateTime for dates
  final DateTime dateLastUpdated; // Use DateTime for dates and clear naming
  final String deck;
  final String description;
  final String distributor;
  final bool hasStaffReview; // Use bool for boolean values

  Movie({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.producers,
    required this.rating,
    required this.releaseDate,
    required this.runtime,
    required this.siteDetailUrl,
    required this.studios,
    required this.totalRevenue,
    required this.writers,
    required this.apiDetailUrl,
    required this.boxOfficeRevenue,
    required this.budget,
    required this.dateAdded,
    required this.dateLastUpdated,
    required this.deck,
    required this.description,
    required this.distributor,
    required this.hasStaffReview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      imageUrl: json['image']?['original_url'] as String? ?? 'default_image_url',
      name: json['name'] as String? ?? '',
      producers: (json['producers'] as List<dynamic>? ?? []).cast<String>(),
      rating: json['rating'] as String? ?? '',
      releaseDate: DateTime.tryParse(json['release_date'] as String? ?? '') ?? DateTime.now(),
      runtime: int.tryParse(json['runtime'] as String? ?? '0') ?? 0,
      siteDetailUrl: json['site_detail_url'] as String? ?? '',
      studios: (json['studios'] as List<dynamic>? ?? []).cast<String>(),
      totalRevenue: int.tryParse(json['total_revenue'] as String? ?? '0') ?? 0,
      writers: (json['writers'] as List<dynamic>? ?? []).cast<String>(),
      apiDetailUrl: json['api_detail_url'] as String? ?? '',
      boxOfficeRevenue: int.tryParse(json['box_office_revenue'] as String? ?? '0') ?? 0,
      budget: int.tryParse(json['budget'] as String? ?? '0') ?? 0,
      dateAdded: DateTime.tryParse(json['date_added'] as String? ?? '') ?? DateTime.now(),
      dateLastUpdated: DateTime.tryParse(json['date_last_updated'] as String? ?? '') ?? DateTime.now(),
      deck: json['deck'] as String? ?? '',
      description: json['description'] as String? ?? '',
      distributor: json['distributor'] as String? ?? '',
      hasStaffReview: json['has_staff_review'] ?? false, // Assuming 'has_staff_review' is a String that represents a boolean
    );
  }
}
