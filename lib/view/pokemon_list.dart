import 'package:flutter/material.dart';
import 'package:pokemon_app/models/pokemon.dart';
import '../controllers/pokemon_controller.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final List<Pokemon> _pokemons = [];
  int _offset = 0;
  bool _loading = false;
  final PokemonController _pokemonController = PokemonController();
  final ScrollController _scrollController = ScrollController();
  late double _width;
  late double _height;
  @override
  void initState() {
    super.initState();

    getPokemons();
    _scrollController.addListener(() {
      double max = _scrollController.position.maxScrollExtent;
      double current = _scrollController.position.pixels;
      if (max <= current + _height / 2) {
        if (_loading) return;
        _offset += 20;
        getPokemons().then((value) {
          createAnimate(current + 50);
        });
      }
    });
  }

  Future<void> getPokemons() async {
    setState(() {
      _loading = true;
    });
    List<Pokemon> newPokemons =
        await _pokemonController.getPokemons(offset: _offset);
    _pokemons.addAll(newPokemons);

    _loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
        onRefresh: () {
          _pokemons.clear();
          _offset = 0;
          return getPokemons();
        },
        child: Stack(
          children: [_buildPokemonList(), _buildCircularProgressIndicator()],
        ));
  }

  Widget _buildPokemonList() {
    if (_pokemons.isEmpty) {
      return const Center(
        child: Text('No pokemons found'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _pokemons.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_pokemons[index].name),
          subtitle: Text(_pokemons[index].url),
        );
      },
    );
  }

  Widget _buildCircularProgressIndicator() {
    return _loading
        ? Positioned(
            bottom: 20,
            left: _width / 2 - 10,
            child: const CircularProgressIndicator(),
          )
        : const SizedBox();
  }

  createAnimate(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
