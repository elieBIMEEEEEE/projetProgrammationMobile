import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/comics.dart';
import '../repositories/comics_repository.dart';

abstract class ComicsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchComics extends ComicsEvent {
  final int limit;
  FetchComics({this.limit = 5});
}

abstract class ComicsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ComicsInitial extends ComicsState {}
class ComicsLoading extends ComicsState {}
class ComicsLoaded extends ComicsState {
  final List<Comics> comics;

  ComicsLoaded(this.comics);
}
class ComicsError extends ComicsState {
  final String error;

  ComicsError(this.error);
}

class ComicsBloc extends Bloc<ComicsEvent, ComicsState> {
  final ComicsRepository comicsRepository;

  ComicsBloc({required this.comicsRepository}) : super(ComicsInitial()) {
    on<FetchComics>((event, emit) async {
      emit(ComicsLoading());
      try {
        final comics = await comicsRepository.fetchComics(limit: event.limit);
        emit(ComicsLoaded(comics));
      } catch (e) {
        emit(ComicsError(e.toString()));
      }
    });
  }
}
