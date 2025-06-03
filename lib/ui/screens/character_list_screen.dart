import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/character_provider.dart';
import '../widgets/сharacter_list_item.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<CharacterProvider>(context, listen: false).fetchCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, characterProvider, child) {
        if (characterProvider.errorMessage != null && characterProvider.characters.isEmpty) {
          return Center(
            child: Text(
              characterProvider.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (characterProvider.characters.isEmpty && characterProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: characterProvider.characters.length + (characterProvider.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == characterProvider.characters.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final character = characterProvider.characters[index];
            return CharacterListItem(character: character);
          },
        );
      },
    );
  }
}