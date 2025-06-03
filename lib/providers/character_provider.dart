import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/local_data_service.dart';

enum CharacterSortOption {
  none,
  nameAsc,
  nameDesc,
  statusAsc,
  speciesAsc,
  speciesDesc,
}

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CharacterLocalDataService _localDataService = CharacterLocalDataService();

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _nextPageUrl;
  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  CharacterSortOption _sortOption = CharacterSortOption.none;
  CharacterSortOption get sortOption => _sortOption;

  CharacterProvider() {
    _initServicesAndLoadCharacters();
  }

  Future<void> _initServicesAndLoadCharacters() async {
    await _localDataService.init();

    if (!_localDataService.isCharactersCacheEmpty()) {
      _characters = _localDataService.getCachedCharacters().map((character) {
        return character.copyWith(isFavorite: _localDataService.isFavorite(character.id));
      }).toList();
      notifyListeners();
    }

    await fetchCharacters(isInitialLoad: true);
  }

  Future<void> fetchCharacters({bool isInitialLoad = false}) async {
    if (_isLoading) return;
    if (!isInitialLoad && !_hasMorePages) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> apiResponse = await _apiService.fetchCharacters(
        nextUrl: isInitialLoad ? null : _nextPageUrl,
      );

      final List<Character> fetchedCharacters = apiResponse['characters'];
      _nextPageUrl = apiResponse['nextPageUrl'];
      _hasMorePages = _nextPageUrl != null;

      if (isInitialLoad) {
        await _localDataService.clearCharactersCache();
      }
      for (var character in fetchedCharacters) {
        await _localDataService.putCharacterInCache(character);
      }

      List<Character> updatedCharacters;
      if (isInitialLoad) {
        updatedCharacters = fetchedCharacters;
      } else {
        final existingCharacterIds = _characters.map((c) => c.id).toSet();
        final uniqueNewCharacters = fetchedCharacters.where((c) => !existingCharacterIds.contains(c.id)).toList();
        updatedCharacters = List.of(_characters)..addAll(uniqueNewCharacters);
      }

      _characters = updatedCharacters.map((character) {
        final bool isCurrentlyFavorite = _localDataService.isFavorite(character.id);
        return character.copyWith(isFavorite: isCurrentlyFavorite);
      }).toList();

    } catch (e) {
      _errorMessage = 'Error loading characters: $e';

      if (_localDataService.isCharactersCacheEmpty() && _characters.isEmpty) {
      } else if (_characters.isEmpty) {
        _characters = _localDataService.getCachedCharacters().map((character) {
          return character.copyWith(isFavorite: _localDataService.isFavorite(character.id));
        }).toList();
        _errorMessage = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Character character) {
    if (_localDataService.isFavorite(character.id)) {
      _localDataService.removeFavorite(character.id);
      character.isFavorite = false;
    } else {
      _localDataService.addFavorite(character.id);
      character.isFavorite = true;
    }

    final index = _characters.indexWhere((char) => char.id == character.id);
    if (index != -1) {
      _characters[index] = character.copyWith(isFavorite: character.isFavorite);
      _localDataService.putCharacterInCache(_characters[index]);
    }
    notifyListeners();
  }

  List<Character> get sortedFavoriteCharacters {
    List<Character> favorites = _characters.where((character) => character.isFavorite).toList();

    switch (_sortOption) {
      case CharacterSortOption.nameAsc:
        favorites.sort((a, b) => (a.name).compareTo(b.name));
        break;
      case CharacterSortOption.nameDesc:
        favorites.sort((a, b) => (b.name).compareTo(a.name));
        break;
      case CharacterSortOption.statusAsc:
        favorites.sort((a, b) => (a.status).compareTo(b.status));
        break;
      case CharacterSortOption.speciesAsc:
        favorites.sort((a, b) => (a.species).compareTo(b.species));
        break;
      case CharacterSortOption.speciesDesc:
        favorites.sort((a, b) => (b.species).compareTo(a.species));
        break;
      case CharacterSortOption.none:
        break;
    }
    return favorites;
  }

  void setSortOption(CharacterSortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    notifyListeners();
  }
}