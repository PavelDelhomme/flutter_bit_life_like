import 'package:hive/hive.dart';
import 'package:bitlife_like/core/shared/bank_account.dart';

class BankAccountAdapter extends TypeAdapter<BankAccount> {
  @override
  final int typeId = 7;

  @override
  BankAccount read(BinaryReader reader) {
    // Adapté selon les besoins – ici exemple simplifié
    return BankAccount(
      id: reader.readString(),
      accountNumber: reader.readString(),
      bankName: reader.readString(),
      accountType: AccountType.values[reader.readInt()],
      balance: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, BankAccount obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.accountNumber);
    writer.writeString(obj.bankName);
    writer.writeInt(obj.accountType.index);
    writer.writeDouble(obj.balance);
  }
}
