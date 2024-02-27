class Movie {
  final String id;
  final String name;
  final String deck;
  final String description;
  final String imageUrl;
  final String releaseDate;
  final String boxOfficeRevenue;
  final String director;
  final int runtime;
  final String studio;

  Movie({
    required this.id,
    required this.name,
    this.deck = '',
    this.description = '',
    required this.imageUrl,
    required this.releaseDate,
    this.boxOfficeRevenue = '',
    this.director = '',
    this.runtime = 0,
    this.studio = '',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      name: json['name'] ?? 'Name not available',
      deck: json['deck'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'default_image_url',
      releaseDate: json['release_date'] ?? 'Release date not available',
      boxOfficeRevenue: json['box_office_revenue']?.toString() ?? 'Revenue not available',
      director: json['director'] ?? 'Director not available',
      runtime: json['runtime'] != null ? int.parse(json['runtime']) : 0,
      studio: json['studio'] ?? 'Studio not available',
    );
  }
}
