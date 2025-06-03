import 'package:hive/hive.dart';
import '../models/character_model.dart';

class CharacterLocalDataService {
  late Box<int> _favoriteBox;
  late Box<Character> _charactersCacheBox;

  Future<void> init() async {
    _favoriteBox = await Hive.openBox<int>('favorite_character_ids');
    _charactersCacheBox = await Hive.openBox<Character>('characters_cache');
  }

  List<Character> getCachedCharacters() {
    return _charactersCacheBox.values.toList();
  }

  bool isCharactersCacheEmpty() {
    return _charactersCacheBox.isEmpty;
  }

  Future<void> clearCharactersCache() async {
    await _charactersCacheBox.clear();
  }

  Future<void> putCharacterInCache(Character character) async {
    await _charactersCacheBox.put(character.id, character);
  }

  bool isFavorite(int characterId) {
    return _favoriteBox.containsKey(characterId);
  }

  Future<void> addFavorite(int characterId) async {
    await _favoriteBox.put(characterId, characterId);
  }

  Future<void> removeFavorite(int characterId) async {
    await _favoriteBox.delete(characterId);
  }
}