import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon_app/models/pokemon.dart';

class PokemonController {
  final apiUrl = 'https://pokeapi.co/api/v2/pokemon';
  Future<List<Pokemon>> getPokemons({required int offset}) async {
    http.Response response =
        await http.get(Uri.parse("$apiUrl?offset=$offset&limit=20"));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];

      return results.map((pokemonMap) {
        return Pokemon.fromJson(pokemonMap);
      }).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }
}
