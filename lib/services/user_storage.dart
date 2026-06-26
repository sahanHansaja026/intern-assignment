import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserStorage {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  // Read users
  static Future<List<dynamic>> readUsers() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      return jsonDecode(content);
    } catch (e) {
      return [];
    }
  }

  // Save user
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final file = await _getFile();

    List<dynamic> users = await readUsers();

    users.add(user);

    await file.writeAsString(jsonEncode(users));
  }
}
