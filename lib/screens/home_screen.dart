import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/series_bloc.dart';
import '../blocs/comic_bloc.dart';
import '../blocs/movie_bloc.dart';
import '../widgets/home_screen_items_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SeriesBloc>().add(FetchSeries(limit: 5));
    context.read<ComicBloc>().add(FetchComics(limit: 5));
    context.read<MovieBloc>().add(FetchMovies(limit: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF152630),
          appBar: AppBar(
            backgroundColor: const Color(0xFF152630),
            elevation: 0,
            title: const Text(
              'Bienvenue !',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            titleSpacing: 26,
            // Aligner le titre à gauche
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  BlocBuilder<SeriesBloc, SeriesState>(
                    builder: (context, state) {
                      if (state is SeriesLoaded) {
                        return ItemsListWidget(
                          title: 'Séries populaires',
                          items: state.series,
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  BlocBuilder<ComicBloc, ComicState>(
                    builder: (context, state) {
                      if (state is ComicsLoaded) {
                        return ItemsListWidget(
                          title: 'Comics populaires',
                          items: state.comics,
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  BlocBuilder<MovieBloc, MovieState>(
                    builder: (context, state) {
                      if (state is MoviesLoaded) {
                        return ItemsListWidget(
                          title: 'Films populaires',
                          items: state.movies,
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF0F1E2B),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/navbar_home.svg',
                      color: const Color(0xFF778BA8)),
                  activeIcon: SvgPicture.asset('assets/icons/navbar_home.svg',
                      color: const Color(0xFF3284e7)),
                  label: 'Accueil',
                  backgroundColor: const Color(0xFF0F1E2B),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                      color: const Color(0xFF778BA8)),
                  activeIcon: SvgPicture.asset('assets/icons/navbar_comics.svg',
                      color: const Color(0xFF3284e7)),
                  label: 'Comics',
                  backgroundColor: const Color(0xFF0F1E2B),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/navbar_series.svg',
                      color: const Color(0xFF778BA8)),
                  activeIcon: SvgPicture.asset('assets/icons/navbar_series.svg',
                      color: const Color(0xFF3284e7)),
                  label: 'Séries',
                  backgroundColor: const Color(0xFF0F1E2B),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/navbar_movies.svg',
                      color: const Color(0xFF778BA8)),
                  activeIcon: SvgPicture.asset('assets/icons/navbar_movies.svg',
                      color: const Color(0xFF3284e7)),
                  label: 'Films',
                  backgroundColor: const Color(0xFF0F1E2B),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/navbar_search.svg',
                      color: const Color(0xFF778BA8)),
                  activeIcon: SvgPicture.asset('assets/icons/navbar_search.svg',
                      color: const Color(0xFF3284e7)),
                  label: 'Recherche',
                  backgroundColor: const Color(0xFF0F1E2B),
                ),
              ],
              selectedItemColor: const Color(0xFF3284e7),
              unselectedItemColor: const Color(0xFF778BA8),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context)
              .padding
              .top, // Position right below the status bar
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
    );
  }
}
