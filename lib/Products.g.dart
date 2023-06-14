// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 0;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products()
      ..name = fields[0] as String
      ..description = fields[1] as String
      ..Price = fields[2] as int
      ..type = fields[3] as String?
      ..orders = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.Price)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.orders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
