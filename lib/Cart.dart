import 'package:buns_out/Products.dart';
import 'package:hive/hive.dart';

part 'Cart.g.dart';

@HiveType(typeId: 1)
class Cart extends HiveObject {
  @HiveField(0)
  late int number;
  @HiveField(1)
  late List<Products> items;
  @HiveField(2)
  late int Total = 0;
}
