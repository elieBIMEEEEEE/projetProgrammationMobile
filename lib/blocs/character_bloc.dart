import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/character.dart';
import '../repositories/character_repository.dart';

// Events
abstract class CharacterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCharacters extends CharacterEvent {
  final int limit;
  FetchCharacters({this.limit = 50}); // Adaptez selon les besoins de pagination
}

// States
abstract class CharacterState extends Equatable {
  @override
  List<Object> get props => [];
}

class CharacterInitial extends CharacterState {}
class CharacterLoading extends CharacterState {}
class CharactersLoaded extends CharacterState {
  final List<Character> characters;
  CharactersLoaded(this.characters);
}
class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);
}

// Bloc
class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;

  CharacterBloc({required this.characterRepository}) : super(CharacterInitial()) {
    on<FetchCharacters>((event, emit) async {
      emit(CharacterLoading());
      try {
        final characters = await characterRepository.fetchCharacters(limit: event.limit);
        emit(CharactersLoaded(characters));
      } catch (e) {
        emit(CharacterError(e.toString()));
      }
    });
  }
}
