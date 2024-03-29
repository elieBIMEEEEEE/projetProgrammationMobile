import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_svg/svg.dart';
import '../blocs/character_bloc.dart';
import '../blocs/serie_bloc.dart';
import '../blocs/series_bloc.dart';
import '../models/character.dart';
import '../models/episode.dart';
import '../models/movie.dart';
import '../models/serie.dart';
import 'character_detail_screen.dart';

class SerieDetailScreen extends StatefulWidget {
  final String apiDetailUrl;

  SerieDetailScreen({Key? key, required this.apiDetailUrl}) : super(key: key);

  @override
  _SerieDetailScreenState createState() => _SerieDetailScreenState();
}

class _SerieDetailScreenState extends State<SerieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context
        .read<SerieBloc>()
        .add(FetchSerie(apiDetailUrl: widget.apiDetailUrl));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocBuilder<SerieBloc, SerieState>(
          builder: (context, state) {
            if (state is SerieLoaded &&
                state.serie.apiDetailUrl == widget.apiDetailUrl) {
              return Text(
                state.serie.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              );
            }
            return const Text('Chargement...',
                style: TextStyle(color: Colors.white));
          },
        ),
        centerTitle: false,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<SerieBloc, SerieState>(
        builder: (context, state) {
          if (state is SerieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SerieLoaded &&
              state.serie.apiDetailUrl == widget.apiDetailUrl) {
            context.read<CharacterBloc>().add(
                FetchsCharacterImage(characters: state.serie.characters));
            return _buildMovieDetail(context, state.serie);
          } else if (state is SerieError) {
            return Center(
                child: Text('Erreur: ${state.error}',
                    style: const TextStyle(color: Colors.white)));
          }
          return const Center(
              child: Text('Aucun film trouvé',
                  style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, Serie serie) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(serie.imageUrl, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  serie.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_publisher_bicolor.svg',
                        color: Colors.white,
                        width: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        serie.publisher,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_tv_bicolor.svg',
                        color: Colors.white,
                        width: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${serie.episodes.length} épisodes",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_calendar_bicolor.svg',
                        color: Colors.white,
                        width: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        serie.startYear,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Histoire'),
                      Tab(text: 'Personnages'),
                      Tab(text: 'Episodes'),
                    ],
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: const Color(0xFF778BA8),
                    indicatorColor: const Color(0xFFFA8003),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 5,
                    indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: -10),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E3243),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildWebView(serie.description),
                          _buildCharacters(serie.characters),
                          _buildEpisodesInfo(serie.episodes),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWebView(String url) {
    if (url.isEmpty) {
      return const Center(
          child: Text(
              "Aucune description n'est disponible dans notre base de données.",
              style: TextStyle(color: Colors.white)));
    } else {
      return WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl(Uri.dataFromString(
            '''
  <html lang="en">
  <head title="movie">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@700&display=swap" rel="stylesheet">
    <style>
      body {
        background-color: #1E3243;
        color: white;
        padding: 65px;
        font-size: 40px;
        font-family: 'Nunito', sans-serif;
        font-weight: 600;
      }
       a{
       color: white;
       }
    </style>
  </head>
  <body>$url</body>
  </html>
  ''',
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ).toString());
        },
      );
    }
  }

  Widget _buildCharacters(List<Character> characters) {
    if (characters.isEmpty) {
      return const Center(
          child: Text(
              "Aucun personnage n'est disponible dans notre base de données.",
              style: TextStyle(color: Colors.white)));
    } else {
      return BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharactersImageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharactersImageLoaded) {
            return ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      state.characters[index].imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    state.characters[index].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CharacterDetailScreen(
                              character: state.characters[index]);
                        },
                      ));
                  },
                );
              },
            );
          } else if (state is CharactersImageError) {
            return Center(
                child: Text('Erreur: ${state.message}',
                    style: const TextStyle(color: Colors.white)));
          }
          return const Center(
              child: Text('Aucun personnage trouvé',
                  style: TextStyle(color: Colors.white)));
        },
      );
    }
  }

  Widget _buildEpisodesInfo(List<Episode> episodes) {
    if (episodes.isEmpty) {
      return const Center(
        child: Text(
          "Aucun épisode n'est disponible dans notre base de données.",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF284C6A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    episodes[index].imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episode #${episodes[index].episodeNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        episodes[index].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            DateFormat('dd MMMM yyyy', 'fr_FR')
                                .format(DateTime.parse(episodes[index].airDate)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

}
