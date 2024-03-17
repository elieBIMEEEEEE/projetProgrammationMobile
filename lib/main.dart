import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/blocs/comic_bloc.dart';
import 'package:projet/blocs/movies_bloc.dart';
import 'package:projet/blocs/search_bloc.dart';
import 'package:projet/blocs/series_bloc.dart';
import 'package:projet/repositories/character_repository.dart';
import 'package:projet/repositories/comic_repository.dart';
import 'package:projet/repositories/movie_repository.dart';
import 'package:projet/repositories/movies_repository.dart';
import 'package:projet/repositories/series_repository.dart';
import 'package:projet/screens/main_screen.dart';

import 'blocs/movie_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final SeriesRepository seriesRepository = SeriesRepository();
  final ComicRepository comicRepository = ComicRepository();
  final MoviesRepository moviesRepository = MoviesRepository();
  final MovieRepository movieRepository = MovieRepository();
  final CharacterRepository characterRepository = CharacterRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SeriesBloc>(
          create: (context) => SeriesBloc(seriesRepository: seriesRepository),
        ),
        BlocProvider<ComicBloc>(
          create: (context) => ComicBloc(comicRepository: comicRepository),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(moviesRepository: moviesRepository),
        ),
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(movieRepository: movieRepository),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            characterRepository: characterRepository,
            seriesRepository: seriesRepository,
            comicRepository: comicRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Comics App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(), // Set HomeScreen as the initial route
      ),
    );
  }
}
