import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/series_bloc.dart';
import '../blocs/comics_bloc.dart';
import '../blocs/movies_bloc.dart';
import '../widgets/home_screen_items_list_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onViewMorePressed;

  const HomeScreen({super.key, required this.onViewMorePressed});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadingSeries = true;
  bool isLoadingComics = true;
  bool isLoadingMovies = true;

  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(FetchSeries(limit: 50));
    context.read<ComicsBloc>().add(FetchComics(limit: 50));
    context.read<MoviesBloc>().add(FetchMovies(limit: 50));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SeriesBloc, SeriesState>(
          listener: (context, state) {
            if (state is SeriesLoaded) {
              setState(() => isLoadingSeries = false);
            }
          },
        ),
        BlocListener<ComicsBloc, ComicsState>(
          listener: (context, state) {
            if (state is ComicsLoaded) {
              setState(() => isLoadingComics = false);
            }
          },
        ),
        BlocListener<MoviesBloc, MoviesState>(
          listener: (context, state) {
            if (state is MoviesLoaded) {
              setState(() => isLoadingMovies = false);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF152630),
        appBar: AppBar(
          backgroundColor: const Color(0xFF152630),
          elevation: 0,
          title: const Text(
            'Bienvenue !',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          titleSpacing: 26,
          centerTitle: false,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    BlocBuilder<SeriesBloc, SeriesState>(
                      builder: (context, state) {
                        if (state is SeriesLoaded) {
                          isLoadingSeries = false;
                          return ItemsListWidget(
                            title: 'Séries populaires',
                            items: state.series.take(5).toList(),
                            onViewMorePressed: (index) {
                              widget.onViewMorePressed(1);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    BlocBuilder<ComicsBloc, ComicsState>(
                      builder: (context, state) {
                        if (state is ComicsLoaded) {
                          isLoadingComics = false;
                          return ItemsListWidget(
                            title: 'Comics populaires',
                            items: state.comics.take(5).toList(),
                            onViewMorePressed: (index) {
                              widget.onViewMorePressed(2);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    BlocBuilder<MoviesBloc, MoviesState>(
                      builder: (context, state) {
                        if (state is MoviesLoaded) {
                          isLoadingMovies = false;
                          return ItemsListWidget(
                            title: 'Films populaires',
                            items: state.movies.take(5).toList(),
                            onViewMorePressed: (index) {
                              widget.onViewMorePressed(3);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),                  ],
                ),
              ),
            ),
            if (isLoadingSeries || isLoadingComics || isLoadingMovies)
              const Center(child: CircularProgressIndicator()),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 0,
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  'assets/images/astronaut.svg',
                  // Set the width and height as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
