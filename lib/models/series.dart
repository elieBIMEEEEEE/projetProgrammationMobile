class Series {
  final String id;
  final String name;
  final String deck;
  final String description;
  final String imageUrl;
  final int countOfEpisodes;
  final String publisher;
  final String startYear;
  // Ajoutez d'autres champs au besoin

  Series({
    required this.id,
    required this.name,
    this.deck = '',
    this.description = '',
    required this.imageUrl,
    required this.countOfEpisodes,
    required this.publisher,
    required this.startYear,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'].toString(),
      name: json['name'] ?? 'Name not available', // Utilisez l'opérateur ?? pour fournir une valeur par défaut
      deck: json['deck'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] != null ? json['image']['original_url'] : 'default_image_url',
      countOfEpisodes: json['count_of_episodes'] ?? 0,
      publisher: json['publisher'] != null ? json['publisher']['name'] : 'Publisher not available',
      startYear: json['start_year']?.toString() ?? 'Year not available',
    );
  }
}
