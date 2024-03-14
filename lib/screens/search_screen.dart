import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/blocs/search_bloc.dart';
import 'package:projet/widgets/home_screen_items_list_widget.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(SearchQueryChanged(_searchController.text));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15232E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF223041),
        title: const Text(
          'Recherche',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Comic, film, série...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF15232E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _searchController.clear(),
                    icon: SvgPicture.asset('assets/icons/navbar_search.svg',
                        color: const Color(0xFF778BA8)),
                  )),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return _buildSearchingPrompt();
          } else if (state is SearchSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: _buildItemListWidgets(state),
              ),
            );
          } else if (state is SearchFailure) {
            return Center(child: Text('Erreur de recherche : ${state.error}',
                style: const TextStyle(color: Colors.red)));
            }
                return _buildSearchPrompt();
          },
      ),
    );
  }

  List<Widget> _buildItemListWidgets(SearchState state) {

    final searchState = state as SearchSuccess;

    List<Widget> widgets = [];

    if (searchState.series.isNotEmpty) {
      widgets.add(
        ItemsListWidget(
          title: 'Séries',
          items: searchState.series.take(5).toList(),
          onViewMorePressed: (index) {},
          hasVoirPlus: false,
        ),
      );
    }

    if (searchState.movies.isNotEmpty) {
      widgets.add(
        ItemsListWidget(
          title: 'Films',
          items: searchState.movies.take(5).toList(),
          onViewMorePressed: (index) {},
          hasVoirPlus: false,
        ),
      );
    }

    if (searchState.comics.isNotEmpty) {
      widgets.add(
        ItemsListWidget(
          title: 'Comics',
          items: searchState.comics.take(5).toList(),
          onViewMorePressed: (index) {},
          hasVoirPlus: false,
        ),
      );
    }

    widgets.add(const Padding(padding: EdgeInsets.only(bottom: 60)));

    return widgets;
  }
  Widget _buildSearchPrompt() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 350,
            height: 130,
            padding: const EdgeInsets.only(left: 15, right: 110, top: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3243),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Text.rich(
              TextSpan(
                text: 'Saisissez une recherche pour trouver un ',
                style: TextStyle(color: Color(0xFF3284e7)),
                children: <TextSpan>[
                  TextSpan(
                      text: 'comics',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ', '),
                  TextSpan(
                      text: 'film',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ', '),
                  TextSpan(
                      text: 'série',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' ou '),
                  TextSpan(
                      text: 'personnage',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '.'),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Positioned(
          top: 240,
          left: 280,
          child: SvgPicture.asset(
            'assets/images/astronaut.svg',
            width: 100,
            height: 100,
          ),
        ),
      ],
    );
  }
  Widget _buildSearchingPrompt() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 350,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3243),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Recherche en cours.',
                    style: TextStyle(
                      color: Color(0xFF3284e7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Merci de patienter...',
                    style: TextStyle(
                      color: Color(0xFF3284e7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/astronaut.svg',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ],
    );
  }
}
