import 'package:hive/hive.dart';
import 'character.dart';

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 8;

  @override
  Character read(BinaryReader reader) {
    return Character.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer.writeMap(obj.toJson());
  }
}