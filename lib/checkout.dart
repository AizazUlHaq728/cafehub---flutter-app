import 'package:buns_out/Cart.dart';
import 'package:buns_out/Orders.dart';
import 'package:buns_out/Products.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class checkout extends StatefulWidget {
  const checkout({Key? key}) : super(key: key);

  @override
  State<checkout> createState() => _checkout();
}

class _checkout extends State<checkout> {
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
                    width: _width * 0.7,
                    child: Text(
                      'Product',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.3,
                    child: Text(
                      'Price',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
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
                box: Hive.box<Cart>('Cart'),
                builder: ((context, box) {
                  Cart raw = box.get(1);
                  List<Products> list = raw.items;
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Products p = list[index];
                        return Column(
                          children: [
                            SizedBox(
                              width: _width,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _width * 0.7,
                                    child: Text(
                                      p.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.3,
                                    child: Text(
                                      "Rs " + p.Price.toString(),
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
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
        width: double.infinity,
        height: _height * 0.08,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final box = Hive.box<Cart>('Cart');
                  Cart? c = box.get(1);
                  c?.delete();
                  box.put(
                    1,
                    Cart()
                      ..Total = 0
                      ..number = 0
                      ..items = [],
                  );
                },
                child: Text(
                  'Clear',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(width: 16.0), // Add spacing between the buttons
            Expanded(
              child: WatchBoxBuilder(
                box: Hive.box<Cart>('Cart'),
                builder: (context, box) {
                  Cart raw = box.get(1);
                  return Visibility(
                    visible: raw.number == 0 ? false : true,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.greenAccent),
                      onPressed: () async {
                        List<Products> temp = raw.items;
                        final box = Hive.box<Products>('Products');
                        for (int i = 0; i < raw.items.length; i++) {
                          Iterable<Products> pj = box.values
                              .where((element) => element.name == temp[i].name)
                              .toList();
                          Products p = pj.first;
                          p.orders++;
                          p.save();
                        }
                        final onebox = Hive.box<Cart>('Cart');
                        Cart? c = onebox.get(1);
                        final orderbox = Hive.box<Orders>('Orders');
                        Orders? op = orderbox.get(1);
                        op?.number++;
                        op?.Total += c!.Total;
                        op?.items.add(c!);
                        op?.save();
                        c?.save();
                        c?.delete();
                        onebox.put(
                          1,
                          Cart()
                            ..Total = 0
                            ..number = 0
                            ..items = [],
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        raw.Total.toString() + ' PKR',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
