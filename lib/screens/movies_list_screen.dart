import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie_bloc.dart'; // Assurez-vous que le chemin d'accès est correct
import '../repositories/movie_repository.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = MovieBloc(movieRepository: MovieRepository());
        bloc.add(FetchMovies()); // Déclenche l'événement immédiatement après la création du bloc
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Movies List")),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MoviesLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ListTile(
                    title: Text(movie.name),
                    subtitle: Text("Release Date: ${movie.imageUrl}"),
                    // Ajoutez plus de détails ici, comme le box office revenue, etc.
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Fetch Movies by dispatching FetchMovies Event"));
          },
        ),
      ),
    );
  }
}
