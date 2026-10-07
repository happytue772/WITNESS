import 'dart:convert';

import 'package:flutter/material.dart';

bool localPhotoExists(String? path) {
  return path != null && path.isNotEmpty;
}

Widget localPhotoImage(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  if (path.startsWith('data:')) {
    final commaIndex = path.indexOf(',');

    if (commaIndex > 0) {
      final encoded = path.substring(commaIndex + 1);

      return Image.memory(
        base64Decode(encoded),
        width: width,
        height: height,
        fit: fit,
      );
    }
  }

  return Image.network(
    path,
    width: width,
    height: height,
    fit: fit,
  );
}
