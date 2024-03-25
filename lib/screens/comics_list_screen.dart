import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/comics_bloc.dart';
import '../widgets/comics_list_screen_widget.dart';

class ComicsListScreen extends StatefulWidget {
  const ComicsListScreen({Key? key}) : super(key: key);

  @override
  _ComicListScreenState createState() => _ComicListScreenState();
}

class _ComicListScreenState extends State<ComicsListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF152630),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Comics les plus populaires',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2, // Permet au texte de s'étendre sur deux lignes
          ),
        ),
        toolbarHeight: 100, // Augmente la hauteur de l'AppBar
      ),

      body: BlocBuilder<ComicsBloc, ComicsState>(
        builder: (context, state) {
          if (state is ComicsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComicsLoaded) {
            return ListView.builder(
              itemCount: state.comics.length,
              itemBuilder: (context, index) {
                return ComicCard(comic: state.comics[index], rank: index + 1);
              },
            );
          } else if (state is ComicsError) {
            return const Center(child: Text('Erreur: Impossible de charger les comics'));
          }
          return Container(); // Fallback empty container
        },
      ),
    );
  }
}
