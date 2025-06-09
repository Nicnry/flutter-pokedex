import 'package:pokedex/data/repositories/api/pokemon_api_repository.dart';
import 'package:pokedex/domain/entities/pokemon.dart';

class PokemonApiService {
  final PokemonApiRepository _repository;

  PokemonApiService(this._repository);

  Future<List<Pokemon>> getPokemons({int limit = 20, int offset = 0}) async {
    try {
      final data = await _repository.getPokemons(limit: limit, offset: offset);
      final results = data['results'] as List<Object?>;

      final pokemonFutures = results
          .cast<Map<dynamic, dynamic>>()
          .map((pokemonData) => getFullPokemon(pokemonData))
          .toList();

      final pokemons = await Future.wait(pokemonFutures);
      return pokemons;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Pokémon: $e');
    }
  }

  Future<Pokemon> getFullPokemon(Map<dynamic, dynamic> pokemonData) async {
    final pokemonUrl = pokemonData['url'] as String;
    final pokemonName = pokemonData['name'] as String;

    final apiResults = await Future.wait([
      _repository.getPokemonByUrl(pokemonUrl),
      _repository.getPokemonByName(pokemonName),
    ]);

    final pokemonDetails = apiResults[0];
    final speciesData = apiResults[1];

    Pokemon pokemon = Pokemon.fromCombinedData(
      pokemonData: pokemonDetails,
      speciesData: speciesData,
      evolutionData: {'chain': {}},
    );
    return pokemon;
  }

  Future<Pokemon?> getPokemonByUrl(String url) async {
    try {
      final data = await _repository.getPokemonByUrl(url);

      return Pokemon.fromApi(data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Pokémon: $e');
    }
  }
}
