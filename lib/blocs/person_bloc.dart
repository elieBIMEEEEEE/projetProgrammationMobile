import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person.dart';
import '../repositories/person_repository.dart';


abstract class PersonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPersons extends PersonEvent {
  final int limit;
  FetchPersons({this.limit = 50});
}

class FetchPersonDetails extends PersonEvent {
  final List<Person> persons;
  FetchPersonDetails({required this.persons});

  @override
  List<Object> get props => [persons];
}

abstract class PersonState extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonsLoaded extends PersonState {
  final List<Person> persons;

  PersonsLoaded(this.persons);
}

class PersonError extends PersonState {
  final String message;

  PersonError(this.message);
}

class PersonsDetailsLoading extends PersonState {}

class PersonsDetailsLoaded extends PersonState {
  final List<Person> persons;

  PersonsDetailsLoaded(this.persons);
}

class PersonsDetailsError extends PersonState {
  final String message;

  PersonsDetailsError(this.message);
}

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository personRepository;

  PersonBloc({required this.personRepository}) : super(PersonInitial()) {
    on<FetchPersons>((event, emit) async {
      emit(PersonLoading());
      try {
        final persons = await personRepository.fetchPersons(limit: event.limit);
        emit(PersonsLoaded(persons));
      } catch (e) {
        emit(PersonError(e.toString()));
      }
    });

    on<FetchPersonDetails>((event, emit) async {
      emit(PersonsDetailsLoading());
      try {
        final persons = await personRepository.fetchPersonsDetails(event.persons);
        emit(PersonsDetailsLoaded(persons));
      } catch (e) {
        emit(PersonsDetailsError(e.toString()));
      }
    });
  }
}