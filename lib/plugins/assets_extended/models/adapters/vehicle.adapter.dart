import 'package:hive/hive.dart';

import '../vehicle.dart';

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 6;

  @override
  Vehicle read(BinaryReader reader) {
    return Vehicle.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer.writeMap(obj.toJson());
  }
}