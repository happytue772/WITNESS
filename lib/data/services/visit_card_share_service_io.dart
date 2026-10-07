import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareVisitCardBytes(
  Uint8List pngBytes, {
  Rect? sharePositionOrigin,
}) async {
  final tempDirectory = await getTemporaryDirectory();

  final filePath =
      '${tempDirectory.path}/'
      'first_witness_visit_card_'
      '${DateTime.now().millisecondsSinceEpoch}.png';

  final file = File(filePath);

  await file.writeAsBytes(
    pngBytes,
    flush: true,
  );

  await SharePlus.instance.share(
    ShareParams(
      title: 'THE FIRST WITNESS',
      text:
          'THE FIRST WITNESS에서 남긴 나의 회복 기록입니다.',
      files: [
        XFile(
          file.path,
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: sharePositionOrigin,
    ),
  );
}
