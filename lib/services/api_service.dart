import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class ApiService {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<Map<String, dynamic>> fetchCharacters({String? nextUrl}) async {
    final url = nextUrl ?? '$_baseUrl/character';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final String? next = data['info']['next'];
      final List<Character> characters = results.map((json) => Character.fromJson(json)).toList();
      return {
        'characters': characters,
        'nextPageUrl': next,
      };
    } else {
      throw Exception('Failed to load characters. Status code: ${response.statusCode}');
    }
  }
}