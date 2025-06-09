import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/config/app_config.dart';
import 'package:pokedex/domain/entities/pokemon.dart';

abstract class BasePokemonRepository {
  @protected
  final String host = AppConfig.baseUrl;

  @protected
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  @protected
  Future<http.Response> getResponse(String endpoint) async {
    final url = '$host/$endpoint';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw HttpException('HTTP ${response.statusCode}: Failed to load $url');
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Object?>> getPokemons({int limit = 20, int offset = 0});
  Future<Map<String, Object?>> getAllPokemons();
  Future<Pokemon?> getPokemonById(int id);
  Future<Map<String, Object?>> getPokemonByUrl(String url);
  Future<Map<String, Object?>> getPokemonByName(String name);
  Future<List<Pokemon>> getPokemonsByType(String type);
}
