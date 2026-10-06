import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MediaStorageService {
  Future<String> savePickedImage(
      String sourcePath,
      ) async {
    final documentsDirectory =
    await getApplicationDocumentsDirectory();

    final journalPhotoDirectory = Directory(
      '${documentsDirectory.path}/journal_photos',
    );

    if (!await journalPhotoDirectory.exists()) {
      await journalPhotoDirectory.create(
        recursive: true,
      );
    }

    final extension = _getExtension(sourcePath);

    final fileName =
        'journal_${DateTime.now().microsecondsSinceEpoch}$extension';

    final destinationPath =
        '${journalPhotoDirectory.path}/$fileName';

    final sourceFile = File(sourcePath);

    final copiedFile = await sourceFile.copy(
      destinationPath,
    );

    return copiedFile.path;
  }

  String _getExtension(String path) {
    final lastSlash = path.lastIndexOf('/');
    final lastBackslash = path.lastIndexOf('\\');

    final fileStart =
    lastSlash > lastBackslash
        ? lastSlash
        : lastBackslash;

    final dotIndex = path.lastIndexOf('.');

    if (dotIndex > fileStart) {
      final extension = path.substring(dotIndex);

      if (extension.length <= 6) {
        return extension;
      }
    }

    return '.jpg';
  }

  Future<void> deleteImage(
      String? path,
      ) async {
    if (path == null) {
      return;
    }

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }
}