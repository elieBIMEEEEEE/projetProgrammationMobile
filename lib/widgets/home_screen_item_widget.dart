import 'package:flutter/material.dart';
import 'package:projet/models/comics.dart';
import 'package:projet/models/movies.dart';
import 'package:projet/models/series.dart';
import 'package:projet/screens/comic_detail_screen.dart';
import 'package:projet/screens/movie_detail_screen.dart';
import 'package:projet/screens/series_detail_screen.dart';

import '../models/character.dart';
import '../models/comic.dart';
import '../models/person.dart';
import '../screens/character_detail_screen.dart';


class ItemWidget extends StatelessWidget {
  final dynamic item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (item is Comics) {
      displayText = item.volume['name'];
      displayText += ' - #${item.issueNumber} - ' + item.name;
    } else {
      displayText = item.name;
    }

    return GestureDetector(
      onTap: () {
        if (item is Comics) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ComicDetailScreen(apiDetailUrl: item.apiDetailUrl)),
          );
        } else if (item is Movies) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MovieDetailScreen(apiDetailUrl: item.apiDetailUrl)),
          );
        } else if (item is Series) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SerieDetailScreen(apiDetailUrl: item.apiDetailUrl)),
          );
        } else if (item is Character) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CharacterDetailScreen(character: item)),
            );
        } else if (item is Comic) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ComicDetailScreen(apiDetailUrl: item.apiDetailUrl)),
          );
        }
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF284C6A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                item.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
              child: Text(
                displayText,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
