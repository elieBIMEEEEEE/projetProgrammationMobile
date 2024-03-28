import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/movies.dart';
import '../repositories/movies_repository.dart';

// Events
abstract class MoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovies extends MoviesEvent {
  final int limit;
  FetchMovies({this.limit = 5});
}

class MoviesLoadMore extends MoviesEvent {
  final int limit;
  MoviesLoadMore({this.limit = 5});
}

abstract class MoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movies> movies;
  final DateTime timestamp;

  MoviesLoaded(this.movies) : timestamp = DateTime.now();

  @override
  List<Object> get props => [movies, timestamp];
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}

// Bloc
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository moviesRepository;

  MoviesBloc({required this.moviesRepository}) : super(MoviesInitial()) {
    on<FetchMovies>((event, emit) async {
      emit(MoviesLoading());
      try {
        final movies = await moviesRepository.fetchMovies(limit: event.limit);
        emit(MoviesLoaded(movies));
      } catch (e) {
        emit(MoviesError(e.toString()));
      }
    });

    on<MoviesLoadMore>((event, emit) async {
      final currentState = state;
      if (currentState is MoviesLoaded) {
        try {
          final movies = await moviesRepository.fetchMovies(limit: event.limit, offset: currentState.movies.length);
          emit(MoviesLoaded([...currentState.movies, ...movies]));
        } catch (e) {
          emit(MoviesError(e.toString()));
        }
      }
    });
  }
}
