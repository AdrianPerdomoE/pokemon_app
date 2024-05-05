import 'package:flutter/material.dart';
import 'package:pokemon_app/view/pokemon_list.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: PokemonList(),
        ),
      ),
    );
  }
}
