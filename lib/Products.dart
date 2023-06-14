import 'package:hive/hive.dart';

part 'Products.g.dart';

@HiveType(typeId: 0)
class Products extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late int Price;
  @HiveField(3)
  late String? type;
  @HiveField(4)
  late int orders;
}
