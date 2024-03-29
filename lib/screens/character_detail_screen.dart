import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../blocs/character_bloc.dart';
import '../models/character.dart';


class CharacterDetailScreen extends StatefulWidget {
  final Character character;

  CharacterDetailScreen({Key? key, required this.character}) : super(key: key);

  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context
        .read<CharacterBloc>()
        .add(FetchCharacterDetails(character: widget.character));
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
        title: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (context, state) {
            if (state is CharacterDetailsLoaded &&
                state.character.id == widget.character.id) {
              return Text(
                state.character.name,
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
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterDetailsLoaded &&
              state.character.id == widget.character.id) {
            return _buildCharacterDetail(context, state.character);
          } else if (state is CharacterDetailsError) {
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

  Widget _buildCharacterDetail(BuildContext context, Character character) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(character.imageUrl, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
        ),
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
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
                      Tab(text: 'Infos'),
                    ],
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: const Color(0xFF778BA8),
                    indicatorColor: const Color(0xFFFA8003),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 5,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: -20),
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
                          _buildWebView(character.description),
                          _buildInfos(character),
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
  }

  Widget _buildInfos(Character character) {
    return ListView(
      children: [
        _buildDetailItem('Nom de super-héros', character.name),
        _buildDetailItem(
            'Nom réel', character.realName),
        _buildDetailItem(
            'Alias', character.aliases.join(', ')),
        _buildDetailItem(
            'Editeur', character.publisher),
        _buildDetailItem('Créateurs', character.creators
            .map((creator) => creator.name)
            .join(', ')),
        _buildDetailItem('Genre', character.gender),
        _buildDetailItem(
            'Date de naissance', character.birth),
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
