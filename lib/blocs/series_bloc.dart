import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/series.dart';
import '../repositories/series_repository.dart';

// Events
abstract class SeriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSeries extends SeriesEvent {
  final int limit;
  FetchSeries({this.limit = 5});
}

class SeriesLoadMore extends SeriesEvent {
  final int limit;
  SeriesLoadMore({this.limit = 5});
}

abstract class SeriesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SeriesInitial extends SeriesState {}

class SeriesLoading extends SeriesState {}

class SeriesLoaded extends SeriesState {
  final List<Series> series;
  final DateTime timestamp;

  SeriesLoaded(this.series) : timestamp = DateTime.now();

  @override
  List<Object> get props => [series, timestamp];

}

class SeriesError extends SeriesState {
  final String error;

  SeriesError(this.error);
}

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository seriesRepository;

  SeriesBloc({required this.seriesRepository}) : super(SeriesInitial()) {
    on<FetchSeries>((event, emit) async {
      emit(SeriesLoading());
      try {
        final series = await seriesRepository.fetchSeries(limit: event.limit);
        emit(SeriesLoaded(series));
      } catch (e) {
        emit(SeriesError(e.toString()));
      }
    });

    on<SeriesLoadMore>((event, emit) async {
      final currentState = state;
      if (currentState is SeriesLoaded) {
        try {
          final series = await seriesRepository.fetchSeries(limit: event.limit, offset: currentState.series.length);
          emit(SeriesLoaded([...currentState.series, ...series]));
        } catch (e) {
          emit(SeriesError(e.toString()));
        }
      }
    });
  }
}

