import 'dart:io';

import 'package:flutter/material.dart';

bool localPhotoExists(String? path) {
  if (path == null || path.isEmpty) {
    return false;
  }

  return File(path).existsSync();
}

Widget localPhotoImage(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
  );
}
