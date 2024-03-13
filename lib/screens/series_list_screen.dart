import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/series_bloc.dart';
import '../widgets/series_list_screen_widget.dart';

class SeriesListScreen extends StatefulWidget {
  const SeriesListScreen({Key? key}) : super(key: key);

  @override
  _SeriesListScreenState createState() => _SeriesListScreenState();
}

class _SeriesListScreenState extends State<SeriesListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF152630),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Séries les plus populaires',
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

      body: BlocBuilder<SeriesBloc, SeriesState>(
        builder: (context, state) {
          if (state is SeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SeriesLoaded) {
            return ListView.builder(
              itemCount: state.series.length,
              itemBuilder: (context, index) {
                return SeriesCard(serie: state.series[index], rank: index + 1);
              },
            );
          } else if (state is SeriesError) {
            return const Center(child: Text('Erreur: Impossible de charger les comics'));
          }
          return Container(); // Fallback empty container
        },
      ),
    );
  }
}
