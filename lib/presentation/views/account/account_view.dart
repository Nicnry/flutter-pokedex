import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Compte'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Dresseur Pokémon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Niveau Débutant',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations du compte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow('Email', 'dresseur@pokemon.com'),
                    _buildInfoRow('Pokémon capturés', '0'),
                    _buildInfoRow('Pokédex complété', '0%'),
                    _buildInfoRow('Version app', '1.0.0'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.red),
                    title: Text('Paramètres'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.red),
                    title: Text('À propos'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Déconnexion'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('À propos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppConfig.appName}'),
            Text('Version: 1.0.0'),
            SizedBox(height: 10),
            Text('API utilisée:'),
            Text(
              AppConfig.baseUrl,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
