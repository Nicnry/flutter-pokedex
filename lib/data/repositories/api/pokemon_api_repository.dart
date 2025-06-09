import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/data/repositories/api/base_pokemon_repository.dart';
import 'package:pokedex/domain/entities/pokemon.dart';

class PokemonApiRepository extends BasePokemonRepository {
  Future<Map<String, Object?>> getPokemons(
      {int limit = 20, int offset = 0}) async {
    try {
      final response = await getResponse('pokemon?limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load pokemons');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Pokémon: $e');
    }
  }

  Future<Pokemon?> getPokemonById(int id) async {
    try {
      final response = await getResponse(
        'pokemon/$id',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Pokemon.fromApi(data);
      }
    } catch (e) {
      print('Erreur pour Pokémon $id: $e');
    }
    return null;
  }

  @override
  Future<Map<String, Object?>> getAllPokemons() async {
    return await getPokemons(limit: 100000, offset: 0);
  }

  @override
  Future<Map<String, Object?>> getPokemonByName(String name) async {
    try {
      final response = await getResponse(
        'pokemon-species/$name',
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load pokemons');
      }
    } catch (e) {
      print('Erreur pour Pokémon $name: $e');
      throw Exception('Erreur pour Pokémon $name: $e');
    }
  }

  @override
  Future<List<Pokemon>> getPokemonsByType(String type) {
    // TODO: implement getPokemonsByType
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> getPokemonByUrl(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load $url');
      }
    } catch (e) {
      rethrow;
    }
  }
}
