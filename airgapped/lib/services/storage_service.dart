import 'dart:convert';
import 'dart:io';

class StorageService {

  static final file = File("favorites.json");

  static Future<List<String>> loadFavorites() async {

    if (!await file.exists()) {
      return [];
    }

    final data = await file.readAsString();

    return List<String>.from(json.decode(data));
  }

  static Future<void> saveFavorites(List<String> favs) async {

    await file.writeAsString(json.encode(favs));
  }
}