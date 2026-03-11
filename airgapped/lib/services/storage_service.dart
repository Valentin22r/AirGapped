import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/favorites.json');
  }

  static Future<List<String>> loadFavorites() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final data = await file.readAsString();
      final List decoded = json.decode(data);
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      print("Erreur lecture favorites.json: $e");
      return [];
    }
  }

  static Future<void> saveFavorites(List<String> favs) async {
    try {
      final file = await _getFile();
      final unique = favs.toSet().toList();
      await file.writeAsString(json.encode(unique));
    } catch (e) {
      print("Erreur écriture favorites.json: $e");
    }
  }
}