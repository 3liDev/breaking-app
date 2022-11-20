import '../models/characters.dart';
import '../models/quotes.dart';
import '../web_services/characters_web_services.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharactersRepository() async {
    final characters =
        await charactersWebServices.getAllCharactersWebServices();

    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getCharacterQuotesRepository(String charName) async {
    final quotes = await charactersWebServices.getCharacterQuotes(charName);

    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
