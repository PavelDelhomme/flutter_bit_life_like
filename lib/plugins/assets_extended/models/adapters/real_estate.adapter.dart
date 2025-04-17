import 'package:hive/hive.dart';

import '../real_estate.dart';

class RealEstateAdapter extends TypeAdapter<RealEstate> {
  @override
  final int typeId = 5;

  @override
  RealEstate read(BinaryReader reader) {
    return RealEstate.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, RealEstate obj) {
    writer.writeMap(obj.toJson());
  }
}