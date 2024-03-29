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
  FetchCharacters({this.limit = 50});
}

class FetchsCharacterImage extends CharacterEvent {
  final List<Character> characters;
  FetchsCharacterImage({required this.characters});

  @override
  List<Object> get props => [characters];
}

class FetchCharacterDetails extends CharacterEvent {
  final Character character;

  FetchCharacterDetails({required this.character});

  @override
  List<Object> get props => [character];
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

class CharactersImageLoading extends CharacterState {}

class CharactersImageLoaded extends CharacterState {
  final List<Character> characters;

  CharactersImageLoaded(this.characters);
}

class CharactersImageError extends CharacterState {
  final String message;

  CharactersImageError(this.message);
}

class CharacterDetailsLoading extends CharacterState {}

class CharacterDetailsLoaded extends CharacterState {
  final Character character;

  CharacterDetailsLoaded(this.character);
}

class CharacterDetailsError extends CharacterState {
  final String message;

  CharacterDetailsError(this.message);
}


class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;

  CharacterBloc({required this.characterRepository})
      : super(CharacterInitial()) {
    on<FetchCharacters>(onFetchCharacters);
    on<FetchsCharacterImage>(onFetchsCharacterImage);
    on<FetchCharacterDetails>(onFetchCharacterDetails);
  }

  void onFetchCharacters(
      FetchCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());
    try {
      final characters =
          await characterRepository.fetchCharacters(limit: event.limit);
      emit(CharactersLoaded(characters));
    } catch (e) {
      emit(CharacterError(e.toString()));
    }
  }

  void onFetchsCharacterImage(FetchsCharacterImage event, Emitter<CharacterState> emit) async {
    emit(CharactersImageLoading());
    try {
      final characters = await characterRepository.fetchCharactersImage(event.characters);
      emit(CharactersImageLoaded(characters));
    } catch (e) {
      emit(CharactersImageError(e.toString()));
    }
  }

  void onFetchCharacterDetails(FetchCharacterDetails event, Emitter<CharacterState> emit) async {
    emit(CharacterDetailsLoading());
    try {
      final character = await characterRepository.fetchCharacterDetails(event.character);
      emit(CharacterDetailsLoaded(character));
    } catch (e) {
      emit(CharacterDetailsError(e.toString()));
    }
  }

}
