import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future<bool> shareImage(Uint8List imgbyt) async {
  XFile imageFile = XFile.fromData(
    imgbyt,
    name: 'signature.png',
    mimeType: 'image/png',
  );
  final result = await Share.shareXFiles([imageFile], text: 'Signature');
  return result.status == ShareResultStatus.success;
}
