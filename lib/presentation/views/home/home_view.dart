import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.catching_pokemon,
              size: 120,
              color: Colors.red,
            ),
            SizedBox(height: 30),
            Text(
              'Bienvenue dans ${AppConfig.appName} !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Découvrez le monde des Pokémon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Fonctionnalités disponibles :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildFeatureRow(Icons.catching_pokemon, 'Pokédex complet'),
                    _buildFeatureRow(Icons.search, 'Recherche avancée'),
                    _buildFeatureRow(Icons.person, 'Profil personnel'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'API: ${AppConfig.baseUrl}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 20),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}