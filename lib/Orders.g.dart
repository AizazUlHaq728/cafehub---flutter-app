// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Orders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdersAdapter extends TypeAdapter<Orders> {
  @override
  final int typeId = 2;

  @override
  Orders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Orders()
      ..number = fields[0] as int
      ..items = (fields[1] as List).cast<Cart>()
      ..Total = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, Orders obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.Total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
