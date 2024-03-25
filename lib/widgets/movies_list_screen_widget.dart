import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/movies.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movies movie;
  final int rank;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

    String coverDate = DateFormat('yyyy', 'fr_FR').format(DateTime.parse(movie.releaseDate));
    coverDate = coverDate.replaceFirst(coverDate[0], coverDate[0].toUpperCase());

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(apiDetailUrl: movie.apiDetailUrl)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3243),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Apply the border radius here
                      child: Image.network(
                        movie.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4, left: 4),
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: 12,
                      right: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_books_bicolor.svg',
                            color: const Color(0xFF778BA8),
                            width: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.runtime} minutes',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_calendar_bicolor.svg',
                            color: const Color(0xFF778BA8),
                            width: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            coverDate,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
