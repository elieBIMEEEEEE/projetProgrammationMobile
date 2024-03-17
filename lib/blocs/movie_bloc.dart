import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

// Events
abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovie extends MovieEvent {
  final String id;

  FetchMovie({required this.id});
}

// States
abstract class MovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final Movie movie;

  MovieLoaded(this.movie);
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}

// Bloc
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<FetchMovie>((event, emit) async {
      emit(MovieLoading());
      try {
        final movie = await movieRepository.fetchMovie(id: event.id);
        emit(MovieLoaded(movie));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
