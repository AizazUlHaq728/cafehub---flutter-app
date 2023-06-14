import 'package:buns_out/Cart.dart';
import 'package:buns_out/Orders.dart';
import 'package:buns_out/Products.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);
  @override
  State<Order> createState() => _order();
}

class _order extends State<Order> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: Color.fromARGB(139, 0, 0, 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'cafe',
              textScaleFactor: 2,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'hub',
              textScaleFactor: 2,
              style: TextStyle(
                  color: Color.fromRGBO(2255, 215, 0, 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
          child: Container(
        width: _width,
        height: _height * 0.8,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              width: _width,
              child: Row(
                children: [
                  SizedBox(
                    width: _width * 0.2,
                    child: Text(
                      '#',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.6,
                    child: Text(
                      'Order',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.2,
                    child: Text(
                      'Price',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Container(
              width: _width,
              height: _height * 0.7,
              child: WatchBoxBuilder(
                box: Hive.box<Orders>('Orders'),
                builder: ((context, box) {
                  Orders raw = box.get(1);
                  List<Cart> list = raw.items.reversed.toList();
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Cart p = list[index];
                        String o = '';
                        for (int i = 0; i < p.items.length; i++) {
                          o += p.items[i].name.toString();
                          o += ', ';
                        }
                        return Column(
                          children: [
                            SizedBox(
                              width: _width,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _width * 0.2,
                                    child: Text(
                                      (raw.number - index).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.6,
                                    child: Text(
                                      o,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.2,
                                    child: Text(
                                      "Rs " + p.Total.toString(),
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 0.2,
                              color: Colors.black,
                            ),
                          ],
                        );
                      });
                }),
              ),
            )
          ],
        )),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: _width,
        height: _height * 0.05,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: _width * 0.35,
                height: _height * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      final box = Hive.box<Orders>('Orders');
                      Orders? c = box.get(1);
                      c?.delete();
                      box.put(
                          1,
                          Orders()
                            ..Total = 0
                            ..number = 0
                            ..items = []);
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      'Clear',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              SizedBox(
                  width: _width * 0.75,
                  height: _height * 0.08,
                  child: WatchBoxBuilder(
                      box: Hive.box<Orders>('Orders'),
                      builder: ((context, box) {
                        Orders raw = box.get(1);
                        return Visibility(
                            visible: raw.number == 0 ? false : true,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.greenAccent),
                                  onPressed: () {},
                                  child: Center(
                                    child: SizedBox(
                                      width: _width * 0.65,
                                      height: _height * 0.08,
                                      child: Center(
                                        child: Text(
                                          "Rs " + raw.Total.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  )),
                            ));
                      })))
            ],
          ),
        ),
      ),
    );
  }
}
