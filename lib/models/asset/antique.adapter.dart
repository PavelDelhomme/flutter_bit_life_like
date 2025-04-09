import 'package:hive/hive.dart';
import 'antique.dart';

class AntiqueAdapter extends TypeAdapter<Antique> {
  @override
  final int typeId = 1;

  @override
  Antique read(BinaryReader reader) {
    return Antique.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, Antique obj) {
    writer.writeMap(obj.toJson());
  }
}