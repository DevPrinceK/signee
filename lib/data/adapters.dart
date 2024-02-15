import 'dart:typed_data';
import 'package:hive/hive.dart';

class Uint8ListAdapter extends TypeAdapter<Uint8List> {
  @override
  final int typeId =
      128; // You can choose any unique positive integer for typeId

  @override
  Uint8List read(BinaryReader reader) {
    final length = reader.readUint32(); // Read the length of the list
    return Uint8List.fromList(reader.readList(length).cast<int>());
  }

  @override
  void write(BinaryWriter writer, Uint8List obj) {
    writer.writeUint32(obj.length); // Write the length of the list
    writer.writeList(obj.toList());
  }
}
