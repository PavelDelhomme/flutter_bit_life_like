import 'package:hive/hive.dart';
import 'arme.dart';

class ArmeAdapter extends TypeAdapter<Arme> {
  @override
  final int typeId = 2;

  @override
  Arme read(BinaryReader reader) {
    return Arme.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, Arme obj) {
    writer.writeMap(obj.toJson());
  }
}