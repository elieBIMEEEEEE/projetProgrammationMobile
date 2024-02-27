import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/series.dart';
import '../repositories/series_repository.dart';

// Events
abstract class SeriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSeriesList extends SeriesEvent {}

abstract class SeriesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SeriesInitial extends SeriesState {}
class SeriesLoading extends SeriesState {}
class SeriesLoaded extends SeriesState {
  final List<Series> seriesList;

  SeriesLoaded(this.seriesList);
}
class SeriesError extends SeriesState {
  final String error;

  SeriesError(this.error);
}

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository seriesRepository;

  SeriesBloc({required this.seriesRepository}) : super(SeriesInitial()) {
    on<FetchSeriesList>((event, emit) async {
      emit(SeriesLoading());
      try {
        final seriesList = await seriesRepository.fetchSeriesList();
        emit(SeriesLoaded(seriesList));
      } catch (e) {
        emit(SeriesError(e.toString()));
      }
    });
  }
}

