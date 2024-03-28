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
    final ComicsBloc comicsBloc = context.read<ComicsBloc>();

    if (maxScroll - currentScroll <= _scrollThreshold && !_isLoadingMore) {
      _isLoadingMore = true;
      comicsBloc.add(ComicsLoadMore(limit: 20));
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
            'Comics les plus populaires',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: BlocBuilder<ComicsBloc, ComicsState>(
        builder: (context, state) {
          if (state is ComicsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComicsLoaded) {
            _isLoadingMore = false;
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.comics.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.comics.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ComicCard(comic: state.comics[index], rank: index + 1);
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
