import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/models/comic.dart';
import 'package:projet/models/movie.dart';
import 'package:projet/models/series.dart';
import 'package:projet/repositories/comic_repository.dart';
import 'package:projet/repositories/movie_repository.dart';
import 'package:projet/repositories/series_repository.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchSuccess extends SearchState {
  final List<Movie> movies;
  final List<Series> series;
  final List<Comic> comics;

  SearchSuccess(this.movies, this.series, this.comics);

  @override
  List<Object> get props => [movies, series, comics];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;
  final SeriesRepository seriesRepository;
  final ComicRepository comicRepository;

  SearchBloc({
    required this.movieRepository,
    required this.seriesRepository,
    required this.comicRepository,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final movies = await movieRepository.searchMovies(event.query);
      final series = await seriesRepository.searchSeries(event.query);
      final comics = await comicRepository.searchComics(event.query);
      emit(SearchSuccess(movies, series, comics));
    } catch (error) {
      emit(SearchFailure(error.toString()));
    }
  }
}
