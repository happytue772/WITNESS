import 'dart:typed_data';
import 'dart:ui';

import 'package:share_plus/share_plus.dart';

Future<void> shareVisitCardBytes(
  Uint8List pngBytes, {
  Rect? sharePositionOrigin,
}) async {
  await SharePlus.instance.share(
    ShareParams(
      title: 'THE FIRST WITNESS',
      text:
          'THE FIRST WITNESS에서 남긴 나의 회복 기록입니다.',
      files: [
        XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'first_witness_visit_card.png',
        ),
      ],
      fileNameOverrides: const [
        'first_witness_visit_card.png',
      ],
      sharePositionOrigin: sharePositionOrigin,
    ),
  );
}
