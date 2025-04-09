import 'package:hive/hive.dart';
import 'assets.dart';

class AssetAdapter extends TypeAdapter<Asset> {
  @override
  final int typeId = 3;

  @override
  Asset read(BinaryReader reader) {
    return Asset.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, Asset obj) {
    writer.writeMap(obj.toJson());
  }
}