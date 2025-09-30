import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/html.dart' as html;

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    if (kIsWeb) {
      html.window.localStorage[key] = value;
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      return html.window.localStorage[key];
    } else {
      return await _storage.read(key: key);
    }
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      html.window.localStorage.remove(key);
    } else {
      await _storage.delete(key: key);
    }
  }
}