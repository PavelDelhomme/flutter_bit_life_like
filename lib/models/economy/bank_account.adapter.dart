// bank_account.adapter.dart
import 'package:hive/hive.dart';
import 'bank_account.dart';

class BankAccountAdapter extends TypeAdapter<BankAccount> {
  @override
  final int typeId = 7;

  @override
  BankAccount read(BinaryReader reader) {
    return BankAccount.fromJson(reader.readMap().cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, BankAccount obj) {
    writer.writeMap(obj.toJson());
  }
}
