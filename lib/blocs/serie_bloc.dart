import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/serie.dart';
import '../repositories/serie_repository.dart';

abstract class SerieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSerie extends SerieEvent {
  final String apiDetailUrl;

  FetchSerie({required this.apiDetailUrl});
}

abstract class SerieState extends Equatable {
  @override
  List<Object> get props => [];
}

class SerieInitial extends SerieState {}

class SerieLoading extends SerieState {
}

class SerieLoaded extends SerieState {
  final Serie serie;

  SerieLoaded(this.serie);
}

class SerieError extends SerieState {
  final String error;

  SerieError(this.error);
}

class SerieBloc extends Bloc<SerieEvent, SerieState> {
  final SerieRepository serieRepository;

  SerieBloc({required this.serieRepository}) : super(SerieInitial()) {
    on<FetchSerie>((event, emit) async {
      emit(SerieLoading());
      try {
        final series = await serieRepository.fetchSerie(apiDetailUrl: event.apiDetailUrl);
        emit(SerieLoaded(series));
      } catch (e) {
        emit(SerieError(e.toString()));
      }
    });
  }
}