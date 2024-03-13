import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet/models/series.dart';

class SeriesCard extends StatelessWidget {
  final Series serie;
  final int rank;

  const SeriesCard({
    Key? key,
    required this.serie,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
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
                      serie.imageUrl,
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
                      serie.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),


                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_publisher_bicolor.svg',
                          color: const Color(0xFF778BA8),
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            serie.publisher,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_tv_bicolor.svg',
                          color: const Color(0xFF778BA8),
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          serie.countOfEpisodes.toString(),
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
                          serie.startYear,
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
    );
  }
}
