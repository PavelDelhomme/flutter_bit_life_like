import 'package:hive/hive.dart';
import 'jewelry.dart';

class JewelryAdapter extends TypeAdapter<Jewelry> {
  @override
  final int typeId = 4;

  @override
  Jewelry read(BinaryReader reader) {
    return Jewelry.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, Jewelry obj) {
    writer.writeMap(obj.toJson());
  }
}