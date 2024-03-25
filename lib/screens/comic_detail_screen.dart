import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projet/blocs/person_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_svg/svg.dart';
import '../blocs/character_bloc.dart';
import '../blocs/comic_bloc.dart';
import '../models/character.dart';
import '../models/comic.dart';
import '../models/person.dart';

class ComicDetailScreen extends StatefulWidget {
  final String apiDetailUrl;

  ComicDetailScreen({Key? key, required this.apiDetailUrl}) : super(key: key);

  @override
  _ComicDetailScreenState createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context
        .read<ComicBloc>()
        .add(FetchComic(apiDetailUrl: widget.apiDetailUrl));
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
        title: BlocBuilder<ComicBloc, ComicState>(
          builder: (context, state) {
            if (state is ComicLoaded &&
                state.comic.apiDetailUrl == widget.apiDetailUrl) {
              return Text(
                state.comic.volume['name'],
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
      body: BlocBuilder<ComicBloc, ComicState>(
        builder: (context, state) {
          if (state is ComicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComicLoaded &&
              state.comic.apiDetailUrl == widget.apiDetailUrl) {
            return _buildComicDetail(context, state.comic);
          } else if (state is ComicError) {
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

  Widget _buildComicDetail(BuildContext context, Comic comic) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(comic.imageUrl, fit: BoxFit.cover),
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
                  comic.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      comic.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_books_bicolor.svg',
                        color: Colors.white,
                        width: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'N° ${comic.issueNumber}',
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
                        DateFormat('MMMM yyyy', 'fr_FR')
                            .format(DateTime.parse(comic.coverDate)),
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
                      Tab(text: 'Auteurs'),
                      Tab(text: 'Personnages'),
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
                          _buildWebView(comic.description),
                          _buildCreators(comic.creators),
                          _buildCharacters(comic.characters),
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
  <head title="comic">
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

  Widget _buildCreators(List<Person> characters) {
    context.read<PersonBloc>().add(FetchPersonDetails(persons: characters));
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        if (state is PersonsDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PersonsDetailsLoaded) {
          return ListView.builder(
            itemCount: state.persons.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    state.persons[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  state.persons[index].name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  state.persons[index].country,
                  style: const TextStyle(
                      color: Colors.white70, fontStyle: FontStyle.italic),
                ),
              );
            },
          );
        } else if (state is PersonsDetailsError) {
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

  Widget _buildCharacters(List<Character> characters) {
    context.read<CharacterBloc>().add(FetchsCharacterDetails(characters: characters));
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is CharactersDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CharactersDetailsLoaded){
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
}
