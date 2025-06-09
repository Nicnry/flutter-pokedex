import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/pokemon.dart';
import '../../viewmodels/pokemon/pokemon_viewmodel.dart';

class PokemonDetailView extends StatefulWidget {
  const PokemonDetailView({super.key});

  @override
  State<PokemonDetailView> createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends State<PokemonDetailView> {
  bool _isStatsExpanded = false;
  bool _isAbilitiesExpanded = false;
  bool _isMovesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonViewModel>(
      builder: (context, viewModel, child) {
        final pokemon = viewModel.selectedPokemon;

        if (pokemon == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Erreur'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Text('Aucun Pokémon sélectionné'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_capitalizeName(pokemon.name)),
            backgroundColor: _getTypeColor(pokemon.types.first),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderSection(pokemon),
                _buildBasicInfoSection(pokemon),
                _buildTypesSection(pokemon),
                _buildExpandableStatsSection(pokemon),
                _buildExpandableAbilitiesSection(pokemon),
                _buildExpandableMovesSection(pokemon),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(Pokemon pokemon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getTypeColor(pokemon.types.first),
            _getTypeColor(pokemon.types.first).withOpacity(0.7),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: _buildPokemonImage(pokemon.imageUrl),
            ),
            SizedBox(height: 20),
            Text(
              _capitalizeName(pokemon.name),
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(Pokemon pokemon) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations générales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getTypeColor(pokemon.types.first),
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                  'Numéro', '#${pokemon.id.toString().padLeft(3, '0')}'),
              _buildInfoRow('Nom', _capitalizeName(pokemon.name)),
              _buildInfoRow(
                  'Taille', '${(pokemon.height / 10).toStringAsFixed(1)} m'),
              _buildInfoRow(
                  'Poids', '${(pokemon.weight / 10).toStringAsFixed(1)} kg'),
              _buildInfoRow(
                  'Expérience de base', '${pokemon.baseExperience} XP'),
              _buildInfoRow('Types',
                  pokemon.types.map((t) => _capitalizeName(t)).join(', ')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypesSection(Pokemon pokemon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Types',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getTypeColor(pokemon.types.first),
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: pokemon.types
                    .map((type) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: _getTypeColor(type).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _capitalizeName(type),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableStatsSection(Pokemon pokemon) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isStatsExpanded = !_isStatsExpanded;
                });
              },
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
                bottom: _isStatsExpanded ? Radius.zero : Radius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Statistiques',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(pokemon.types.first),
                      ),
                    ),
                    Icon(
                      _isStatsExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: _getTypeColor(pokemon.types.first),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (_isStatsExpanded)
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: pokemon.stats
                      .map((stat) => _buildStatBar(
                          _getStatDisplayName(stat.name),
                          stat.baseStat,
                          _getTypeColor(pokemon.types.first)))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableAbilitiesSection(Pokemon pokemon) {
    if (pokemon.abilities.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isAbilitiesExpanded = !_isAbilitiesExpanded;
                });
              },
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
                bottom:
                    _isAbilitiesExpanded ? Radius.zero : Radius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Capacités',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getTypeColor(pokemon.types.first),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor(pokemon.types.first)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${pokemon.abilities.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTypeColor(pokemon.types.first),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _isAbilitiesExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: _getTypeColor(pokemon.types.first),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (_isAbilitiesExpanded)
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: pokemon.abilities
                      .map((ability) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ability.isHidden
                                  ? Colors.orange[100]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ability.isHidden
                                    ? Colors.orange[300]!
                                    : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _capitalizeName(ability.name),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Slot ${ability.slot}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (ability.isHidden)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Cachée',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableMovesSection(Pokemon pokemon) {
    if (pokemon.moves.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isMovesExpanded = !_isMovesExpanded;
                });
              },
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
                bottom: _isMovesExpanded ? Radius.zero : Radius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Attaques',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getTypeColor(pokemon.types.first),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor(pokemon.types.first)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${pokemon.moves.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTypeColor(pokemon.types.first),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _isMovesExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: _getTypeColor(pokemon.types.first),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (_isMovesExpanded)
              Container(
                height: 300,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ListView.builder(
                  itemCount: pokemon.moves.length,
                  itemBuilder: (context, index) {
                    final move = pokemon.moves[index];
                    final levelMoves = move.learnMethods
                        .where((method) => method.method == 'level-up')
                        .toList();
                    final minLevel = levelMoves.isNotEmpty
                        ? levelMoves
                            .map((m) => m.levelLearned)
                            .reduce((a, b) => a < b ? a : b)
                        : null;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _capitalizeName(move.name.replaceAll('-', ' ')),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (minLevel != null && minLevel > 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getTypeColor(pokemon.types.first)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Niv. $minLevel',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getTypeColor(pokemon.types.first),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultPokemonIcon();
        },
      );
    }
    return _buildDefaultPokemonIcon();
  }

  Widget _buildDefaultPokemonIcon() {
    return Icon(
      Icons.catching_pokemon,
      color: Colors.white,
      size: 100,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String statName, int value, Color color) {
    final percentage = value / 150.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatDisplayName(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return 'Points de Vie';
      case 'attack':
        return 'Attaque';
      case 'defense':
        return 'Défense';
      case 'special-attack':
        return 'Attaque Spé.';
      case 'special-defense':
        return 'Défense Spé.';
      case 'speed':
        return 'Vitesse';
      default:
        return _capitalizeName(statName);
    }
  }

  String _capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow[700]!;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.lightBlue;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.grey[800]!;
      case 'fairy':
        return Colors.pink[200]!;
      case 'fighting':
        return Colors.red[800]!;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.lightBlue[200]!;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      case 'normal':
        return Colors.grey[400]!;
      default:
        return Colors.grey;
    }
  }
}
