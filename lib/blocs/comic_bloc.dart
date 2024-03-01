import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/comic.dart';
import '../repositories/comic_repository.dart';

abstract class ComicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComics extends ComicEvent {
  final int limit;
  FetchComics({this.limit = 5});
}

abstract class ComicState extends Equatable {
  @override
  List<Object> get props => [];
}

class ComicInitial extends ComicState {}
class ComicLoading extends ComicState {}
class ComicsLoaded extends ComicState {
  final List<Comic> comics;

  ComicsLoaded(this.comics);
}
class ComicError extends ComicState {
  final String error;

  ComicError(this.error);
}

class ComicBloc extends Bloc<ComicEvent, ComicState> {
  final ComicRepository comicRepository;

  ComicBloc({required this.comicRepository}) : super(ComicInitial()) {
    on<FetchComics>((event, emit) async {
      emit(ComicLoading());
      try {
        final comics = await comicRepository.fetchComics(limit: event.limit);
        emit(ComicsLoaded(comics));
      } catch (e) {
        emit(ComicError(e.toString()));
      }
    });
  }
}
