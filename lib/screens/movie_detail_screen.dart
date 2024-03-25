import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_svg/svg.dart';
import '../blocs/character_bloc.dart';
import '../blocs/movie_bloc.dart';
import '../models/character.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final String apiDetailUrl;

  MovieDetailScreen({Key? key, required this.apiDetailUrl}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MovieBloc>().add(FetchMovie(apiDetailUrl: widget.apiDetailUrl));
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
        title: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoaded && state.movie.apiDetailUrl == widget.apiDetailUrl) {
              return Text(
                state.movie.name,
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
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded && state.movie.apiDetailUrl == widget.apiDetailUrl) {
            context.read<CharacterBloc>().add(FetchsCharacterDetails(characters: state.movie.characters));
            return _buildMovieDetail(context, state.movie);
          } else if (state is MovieError) {
            return Center(
                child: Text('Erreur: ${state.message}',
                    style: const TextStyle(color: Colors.white)));
          }
          return const Center(
              child: Text('Aucun film trouvé',
                  style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  Widget _buildMovieDetail(BuildContext context, Movie movie) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(movie.imageUrl, fit: BoxFit.cover),
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
                  movie.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_movie_bicolor.svg',
                        color: Colors.white,
                        width: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${movie.runtime} minutes",
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
                        DateTime.parse(movie.releaseDate).year.toString(),
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
                      Tab(text: 'Synopsis'),
                      Tab(text: 'Personnages'),
                      Tab(text: 'Infos'),
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
                          _buildWebView(movie.description),
                          _buildCharacters(movie.characters),
                          _buildInfos(movie),
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

  Widget _buildCharacters(List<Character> characters) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is CharactersDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharactersDetailsLoaded) {
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
              );
            },
          );
        } else if (state is CharactersDetailsError) {
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


  String formatRevenue(String revenueString) {
    double revenue = double.tryParse(revenueString.replaceAll(r'$', '')) ?? 0;
    if (revenue >= 1000000) {
      double formattedRevenue = revenue / 1000000;
      return "${formattedRevenue.toStringAsFixed(2)} millions \$";
    } else if (revenue >= 1000) {
      double formattedRevenue = revenue / 1000;
      return "${formattedRevenue.toStringAsFixed(2)} mille \$";
    } else if(revenue == 0){
      return "Inconnu";
    } else {
      return "$revenue \$";
    }
  }

  Widget _buildInfos(Movie movie) {
    return ListView(
      children: [
        _buildDetailItem('Classification', movie.rating),
        _buildDetailItem('Scénaristes', movie.writers.map((e) => e.name).join(', ')),
        _buildDetailItem('Producteurs', movie.producers.map((e) => e.name).join(', ')),
        _buildDetailItem('Studios', movie.studios.map((e) => e.name).join(', ')),
        _buildDetailItem('Budget', formatRevenue(movie.budget)),
        _buildDetailItem(
            'Recettes au box-office', formatRevenue(movie.boxOfficeRevenue)),
        _buildDetailItem(
            'Recettes brutes totales', formatRevenue(movie.totalRevenue)),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
