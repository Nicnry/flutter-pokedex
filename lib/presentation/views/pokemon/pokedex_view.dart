import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/app_config.dart';
import '../../viewmodels/pokemon/pokemon_viewmodel.dart';
import '../../../domain/entities/pokemon.dart';

class PokedexView extends StatelessWidget {
  const PokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<PokemonViewModel>().refreshPokemonList();
            },
          ),
        ],
      ),
      body: Consumer<PokemonViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.pokemonList.isEmpty) {
            return _buildLoadingState();
          }

          if (viewModel.hasError && viewModel.pokemonList.isEmpty) {
            return _buildErrorState(viewModel.errorMessage!, viewModel);
          }

          if (viewModel.pokemonList.isNotEmpty) {
            return _buildPokemonList(context, viewModel);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          SizedBox(height: 16),
          Text(
            'Chargement des Pokémon...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, PokemonViewModel viewModel) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Oups !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.refreshPokemonList(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonList(BuildContext context, PokemonViewModel viewModel) {
    return RefreshIndicator(
      onRefresh: viewModel.refreshPokemonList,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.8) {
            if (viewModel.hasMore && !viewModel.isLoadingMore) {
              viewModel.loadMorePokemon();
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: viewModel.pokemonList.length + (viewModel.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == viewModel.pokemonList.length) {
              return _buildLoadingMoreWidget();
            }

            final pokemon = viewModel.pokemonList[index];
            return _buildPokemonCard(context, pokemon, viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingMoreWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            SizedBox(height: 12),
            Text(
              'Chargement de plus de Pokémon...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(
      BuildContext context, Pokemon pokemon, PokemonViewModel viewModel) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: _buildPokemonImage(pokemon.imageUrl),
        title: Text(
          _capitalizeName(pokemon.name),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: _buildPokemonTypes(pokemon.types),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          viewModel.selectPokemon(pokemon);
          _showPokemonDetails(context, pokemon);
        },
      ),
    );
  }

  Widget _buildPokemonImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultPokemonIcon();
          },
        ),
      );
    }
    return _buildDefaultPokemonIcon();
  }

  Widget _buildDefaultPokemonIcon() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.red,
      child: Icon(
        Icons.catching_pokemon,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildPokemonTypes(List<String> types) {
    return Wrap(
      spacing: 4,
      children: types
          .map((type) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _capitalizeName(type),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.catching_pokemon,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Aucun Pokémon trouvé',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showPokemonDetails(BuildContext context, Pokemon pokemon) {
    Navigator.pushNamed(context, '/pokemon-detail');
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
      default:
        return Colors.grey;
    }
  }
}
