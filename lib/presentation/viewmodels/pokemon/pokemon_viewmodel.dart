import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/config/app_config.dart';
import 'package:pokedex/data/repositories/api/pokemon_api_repository.dart';
import 'package:pokedex/data/services/api/pokemon_api_service.dart';
import 'dart:convert';
import 'package:pokedex/domain/entities/pokemon.dart';

class PokemonViewModel extends ChangeNotifier {
  final PokemonApiService _apiService =
      PokemonApiService(PokemonApiRepository());
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  Pokemon? _selectedPokemon;
  int _currentOffset = 0;
  static const int _limit = 20;
  bool _hasMore = true;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  Pokemon? get selectedPokemon => _selectedPokemon;
  bool get hasMore => _hasMore;

  PokemonViewModel() {
    loadPokemonList();
  }

  Future<void> loadPokemonList({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOffset = 0;
      _pokemonList.clear();
      _hasMore = true;
    }

    _setLoading(true);
    _clearError();

    try {
      final pokemons = await _apiService.getPokemons();

      for (int i = 0; i < pokemons.length; i++) {
        _pokemonList.add(pokemons[i]);
      }

      _currentOffset += _limit;
    } catch (e) {
      _setError('Erreur de connexion BITE: ${e.toString()}');
    }

    _setLoading(false);
  }

  Future<void> loadMorePokemon() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    _setLoadingMore(true);

    try {
      final pokemons =
          await _apiService.getPokemons(limit: _limit, offset: _currentOffset);

      for (int i = 0; i < pokemons.length; i++) {
        _pokemonList.add(pokemons[i]);
      }

      _currentOffset += _limit;
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement de plus de Pokémon: $e');
    }

    _setLoadingMore(false);
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }

  Future<void> refreshPokemonList() async {
    await loadPokemonList(isRefresh: true);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
