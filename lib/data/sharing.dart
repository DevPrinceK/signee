import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

void shareImage(Uint8List imgbyt) {
  XFile imageFile = XFile.fromData(imgbyt, name: 'signature.png');
  Share.shareXFiles([imageFile], text: 'Signature');
}
