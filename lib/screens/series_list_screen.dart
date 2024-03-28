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
    final SeriesBloc seriesBloc = context.read<SeriesBloc>();

    if (maxScroll - currentScroll <= _scrollThreshold && !_isLoadingMore) {
      _isLoadingMore = true;
      seriesBloc.add(SeriesLoadMore(limit: 20));
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
            'Séries les plus populaires',
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
      body: BlocBuilder<SeriesBloc, SeriesState>(
        builder: (context, state) {
          if (state is SeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SeriesLoaded) {
            _isLoadingMore = false;
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.series.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.series.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SeriesCard(serie: state.series[index], rank: index + 1);
              },
            );
          } else if (state is SeriesError) {
            return const Center(
                child: Text('Erreur: Impossible de charger les comics'));
          }
          return Container(); // Fallback empty container
        },
      ),
    );
  }
}
