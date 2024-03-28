import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet/models/character.dart';
import 'package:projet/repositories/series_repository.dart';
import 'package:projet/repositories/comic_repository.dart';
import 'package:projet/repositories/person_repository.dart';

import '../models/comic.dart';
import '../models/person.dart';
import '../repositories/character_repository.dart';

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
  final List<Character> characters;
  final List<Comic> comics;
  final List<Person> persons;

  SearchSuccess(this.characters, this.persons, this.comics);

  @override
  List<Object> get props => [characters, persons, comics];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CharacterRepository characterRepository;
  final PersonRepository personRepository;
  final ComicRepository comicRepository;

  SearchBloc({
    required this.characterRepository,
    required this.personRepository,
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
      final characters = await characterRepository.searchCharacters(event.query);
      final persons = await personRepository.searchPersons(event.query);
      final comics = await comicRepository.searchComics(event.query);
      emit(SearchSuccess(characters, persons, comics));
    } catch (error) {
      emit(SearchFailure(error.toString()));
    }
  }
}
