import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/characters.dart';
import '../../data/models/quotes.dart';
import '../../data/repository/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];

  dynamic quotes;
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharactersCubit() {
    charactersRepository.getAllCharactersRepository().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotesCubit(String charName) {
    charactersRepository.getCharacterQuotesRepository(charName).then((quotes) {
      emit(QuotesLoaded(quotes: quotes));
    });
  }
}
