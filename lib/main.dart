import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/blocs/comic_bloc.dart';
import 'package:projet/blocs/movie_bloc.dart';
import 'package:projet/blocs/series_bloc.dart';
import 'package:projet/repositories/comic_repository.dart';
import 'package:projet/repositories/movie_repository.dart';
import 'package:projet/repositories/series_repository.dart';
import 'package:projet/screens/home_screen.dart'; // Make sure to create this file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Repositories are instantiated here. Consider moving this to a BlocProvider if they have to be accessed globally.
  final ComicRepository comicRepository = ComicRepository();
  final SeriesRepository seriesRepository = SeriesRepository();
  final MovieRepository movieRepository = MovieRepository();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ComicBloc>(
          create: (context) => ComicBloc(comicRepository: comicRepository)..add(FetchComics()),
        ),
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(movieRepository: movieRepository)..add(FetchMovies()),
        ),
        BlocProvider<SeriesBloc>(
          create: (context) => SeriesBloc(seriesRepository: seriesRepository)..add(FetchSeriesList()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Comics App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(), // Set HomePage as the initial route
      ),
    );
  }
}
