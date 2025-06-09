class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final int baseExperience;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final List<PokemonMove> moves;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.abilities,
    required this.stats,
    required this.moves,
  });

  factory Pokemon.fromApi(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      abilities: (json['abilities'] as List? ?? [])
          .map((ability) => PokemonAbility.fromJson(ability))
          .toList(),
      stats: (json['stats'] as List? ?? [])
          .map((stat) => PokemonStat.fromJson(stat))
          .toList(),
      moves: (json['moves'] as List? ?? [])
          .map((move) => PokemonMove.fromJson(move))
          .toList(),
    );
  }

  factory Pokemon.fromCombinedData({
    required Map<String, dynamic> pokemonData,
    required Map<String, dynamic> speciesData,
    required Map<String, dynamic> evolutionData,
  }) {
    return Pokemon(
      id: pokemonData['id'],
      name: pokemonData['name'],
      imageUrl: pokemonData['sprites']['front_default'] ?? '',
      types: (pokemonData['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      height: pokemonData['height'] ?? 0,
      weight: pokemonData['weight'] ?? 0,
      baseExperience: pokemonData['base_experience'] ?? 0,
      abilities: (pokemonData['abilities'] as List? ?? [])
          .map((ability) => PokemonAbility.fromJson(ability))
          .toList(),
      stats: (pokemonData['stats'] as List? ?? [])
          .map((stat) => PokemonStat.fromJson(stat))
          .toList(),
      moves: (pokemonData['moves'] as List? ?? [])
          .map((move) => PokemonMove.fromJson(move))
          .toList(),
    );
  }
}

class PokemonAbility {
  final String name;
  final bool isHidden;
  final int slot;

  PokemonAbility({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['ability']['name'],
      isHidden: json['is_hidden'] ?? false,
      slot: json['slot'] ?? 0,
    );
  }
}

class PokemonStat {
  final String name;
  final int baseStat;
  final int effort;

  PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'],
      baseStat: json['base_stat'] ?? 0,
      effort: json['effort'] ?? 0,
    );
  }
}

class PokemonMove {
  final String name;
  final List<MoveLearnMethod> learnMethods;

  PokemonMove({
    required this.name,
    required this.learnMethods,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      name: json['move']['name'],
      learnMethods: (json['version_group_details'] as List? ?? [])
          .map((detail) => MoveLearnMethod.fromJson(detail))
          .toList(),
    );
  }
}

class MoveLearnMethod {
  final String method;
  final int levelLearned;
  final String versionGroup;

  MoveLearnMethod({
    required this.method,
    required this.levelLearned,
    required this.versionGroup,
  });

  factory MoveLearnMethod.fromJson(Map<String, dynamic> json) {
    return MoveLearnMethod(
      method: json['move_learn_method']['name'],
      levelLearned: json['level_learned_at'] ?? 0,
      versionGroup: json['version_group']['name'],
    );
  }
}
