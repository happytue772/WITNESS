import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class MediaStorageService {
  Future<String> savePickedImage(
    XFile sourceFile,
  ) async {
    final bytes = await sourceFile.readAsBytes();

    final mimeType =
        sourceFile.mimeType ?? _mimeTypeFor(sourceFile.name);

    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  String _mimeTypeFor(String name) {
    final lower = name.toLowerCase();

    if (lower.endsWith('.png')) {
      return 'image/png';
    }

    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }

    if (lower.endsWith('.gif')) {
      return 'image/gif';
    }

    return 'image/jpeg';
  }

  Future<void> deleteImage(
    String? path,
  ) async {
    // Web demo images are stored as data URLs in SharedPreferences.
  }
}
