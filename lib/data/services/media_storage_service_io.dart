import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MediaStorageService {
  Future<String> savePickedImage(
    XFile sourceFile,
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

    final extension = _getExtension(sourceFile.path);

    final fileName =
        'journal_${DateTime.now().microsecondsSinceEpoch}$extension';

    final destinationPath =
        '${journalPhotoDirectory.path}/$fileName';

    final copiedFile = await File(
      sourceFile.path,
    ).copy(
      destinationPath,
    );

    return copiedFile.path;
  }

  String _getExtension(String path) {
    final lastSlash = path.lastIndexOf('/');
    final lastBackslash = path.lastIndexOf(r'\');

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
