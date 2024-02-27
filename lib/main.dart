import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/blocs/movie_bloc.dart';
import 'package:projet/blocs/series_bloc.dart';
import 'package:projet/repositories/movie_repository.dart';
import 'package:projet/repositories/series_repository.dart';
import 'package:projet/screens/movies_list_screen.dart';
import 'package:projet/screens/series_list_screen.dart';
import 'blocs/comic_bloc.dart';
import 'repositories/comic_repository.dart';
import 'screens/comics_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ComicRepository comicRepository = ComicRepository();
  final SeriesRepository seriesRepository = SeriesRepository();
  final MovieRepository movieRepository = MovieRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ComicBloc(comicRepository: comicRepository)..add(FetchComics()),
        child: ComicsListScreen(),
      ),
    );
  }
}
