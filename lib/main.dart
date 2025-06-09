import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'presentation/views/navigation/main_navigation_view.dart';
import 'presentation/views/pokemon/pokemon_detail_view.dart';
import 'presentation/viewmodels/pokemon/pokemon_viewmodel.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonViewModel()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MainNavigationView(),
        routes: {
          '/pokemon-detail': (context) => PokemonDetailView(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
