import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/character_model.dart';
import '../../providers/character_provider.dart';
import '../widgets/сharacter_list_item.dart';

class FavoriteCharactersScreen extends StatelessWidget {
  const FavoriteCharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, characterProvider, child) {
        final List<Character> favoriteCharacters = characterProvider.sortedFavoriteCharacters;

        if (favoriteCharacters.isEmpty) {
          return const Center(
            child: Text(
              "You don't have any favorite characters yet..",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: const Text('Favorites'),
            actions: [
              PopupMenuButton<CharacterSortOption>(
                onSelected: (CharacterSortOption result) {
                  characterProvider.setSortOption(result);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<CharacterSortOption>>[
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.none,
                    child: Text('No sorting'),
                  ),
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.nameAsc,
                    child: Text('By name (A-Z)'),
                  ),
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.nameDesc,
                    child: Text('By name (Z-A)'),
                  ),
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.statusAsc,
                    child: Text('By status'),
                  ),
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.speciesAsc,
                    child: Text('By species (A-Z)'),
                  ),
                  const PopupMenuItem<CharacterSortOption>(
                    value: CharacterSortOption.speciesDesc,
                    child: Text('By species (Z-A)'),
                  ),
                ],
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: favoriteCharacters.length,
            itemBuilder: (context, index) {
              final character = favoriteCharacters[index];
              return CharacterListItem(character: character);
            },
          ),
        );
      },
    );
  }
}