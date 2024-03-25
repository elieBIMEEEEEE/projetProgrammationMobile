import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/comic.dart';
import '../repositories/comic_repository.dart';

abstract class ComicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComic extends ComicEvent {
  final String apiDetailUrl;

  FetchComic({required this.apiDetailUrl});
}

abstract class ComicState extends Equatable {
  @override
  List<Object> get props => [];
}

class ComicInitial extends ComicState {}

class ComicLoading extends ComicState {}

class ComicLoaded extends ComicState {
  final Comic comic;

  ComicLoaded(this.comic);
}

class ComicError extends ComicState {
  final String message;

  ComicError(this.message);
}

class ComicBloc extends Bloc<ComicEvent, ComicState> {
  final ComicRepository comicRepository;

  ComicBloc({required this.comicRepository}) : super(ComicInitial()) {
    on<FetchComic>((event, emit) async {
      emit(ComicLoading());
      try {
        final comic = await comicRepository.fetchComic(apiDetailUrl: event.apiDetailUrl);
        emit(ComicLoaded(comic));
      } catch (e) {
        emit(ComicError(e.toString()));
      }
    });
  }
}
