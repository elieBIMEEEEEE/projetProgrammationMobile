import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/comics_bloc.dart';
import '../blocs/movies_bloc.dart';
import '../widgets/movies_list_screen_widget.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({Key? key}) : super(key: key);

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _scrollThreshold = 50;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final MoviesBloc moviesBloc = context.read<MoviesBloc>();

    if (maxScroll - currentScroll <= _scrollThreshold && !_isLoadingMore) {
      _isLoadingMore = true;
      moviesBloc.add(MoviesLoadMore(limit: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152630),
      appBar: AppBar(
        backgroundColor: const Color(0xFF152630),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Films les plus populaires',
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
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MoviesLoaded) {
            _isLoadingMore = false;
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.movies.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return MovieCard(movie: state.movies[index], rank: index + 1);
              },
            );
          } else if (state is ComicsError) {
            return const Center(
                child: Text('Erreur: Impossible de charger les comics'));
          }
          return Container(); // Fallback empty container
        },
      ),
    );
  }
}
