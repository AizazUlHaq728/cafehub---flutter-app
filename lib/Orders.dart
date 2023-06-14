import 'package:buns_out/Cart.dart';
import 'package:buns_out/Products.dart';
import 'package:hive/hive.dart';

part 'Orders.g.dart';

@HiveType(typeId: 2)
class Orders extends HiveObject {
  @HiveField(0)
  late int number;
  @HiveField(1)
  late List<Cart> items;
  @HiveField(2)
  late double Total = 0;
}
