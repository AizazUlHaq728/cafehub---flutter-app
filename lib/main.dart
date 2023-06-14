import 'package:buns_out/Cart.dart';
import 'package:buns_out/OrderPage.dart';
import 'package:buns_out/Orders.dart';
import 'package:buns_out/Products.dart';
import 'package:buns_out/checkout.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductsAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(OrdersAdapter());
  await Hive.openBox<Cart>('Cart');
  final box = Hive.box<Cart>('Cart');
  if (box.get(1) == null) {
    box.put(
        1,
        Cart()
          ..Total = 0
          ..number = 0
          ..items = []);
  }
  await Hive.openBox<Orders>('Orders');
  final orderbox = Hive.box<Orders>('Orders');
  if (orderbox.get(1) == null) {
    orderbox.put(
        1,
        Orders()
          ..Total = 0
          ..number = 0
          ..items = []);
  }
  await Hive.openBox<Products>('Products');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> Items = ['Deals', 'Products', 'Drinks'];
  int addstate = 0;
  final _name = TextEditingController();
  final _dis = TextEditingController();
  final _price = TextEditingController();
  @override
  void dispose() {
    Hive.box('Products').close();
    Hive.box('Cart').close();
    Hive.box('Orders').close(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        width: _width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: _height * 0.15,
              decoration: BoxDecoration(color: Color.fromARGB(139, 0, 0, 5)),
              child: Center(
                child: Row(
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
            ),
            SizedBox(height: _height * 0.02),
            Card(
              child: ListTile(
                title: const Text('Home'),
                tileColor: Color.fromRGBO(67, 94, 113, 100),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('My Cart'),
                tileColor: Color.fromRGBO(67, 94, 113, 100),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const checkout()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Orders'),
                tileColor: Color.fromRGBO(67, 94, 113, 100),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Order()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Add a new product'),
                tileColor: Color.fromRGBO(67, 94, 113, 100),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Add a new product'),
                          content: Form(
                              child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 4, bottom: 4),
                                  child: TextFormField(
                                    controller: _name,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Empty value not allowed';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4, bottom: 4),
                                  child: TextFormField(
                                    controller: _dis,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Description'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4, bottom: 4),
                                  child: TextFormField(
                                    controller: _price,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Price'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Empty value not allowed';
                                      } else if (value == 0) {
                                        return 'Mufte ka kuch ni milta';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4, bottom: 4),
                                  child: DropdownButtonFormField<String>(
                                    value: Items[addstate],
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    onChanged: (String? values) {
                                      setState(() {
                                        if (values == 'Deals')
                                          addstate = 0;
                                        else if (values == 'Products')
                                          addstate = 1;
                                        else
                                          addstate = 2;
                                      });
                                    },
                                    onSaved: (String? values) {
                                      setState(() {
                                        if (values == 'Deals')
                                          addstate = 0;
                                        else if (values == 'Products')
                                          addstate = 1;
                                        else
                                          addstate = 2;
                                      });
                                    },
                                    items: Items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Addprod(
                                          _name.text,
                                          _dis.text,
                                          int.parse(_price.text),
                                          Items[addstate]);
                                      _name.text = "";
                                      _dis.text = "";
                                      _price.text = "";
                                    },
                                    child: Text('Add'))
                              ],
                            ),
                          )),
                        );
                      });
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Clear Account'),
                tileColor: Color.fromRGBO(67, 94, 113, 100),
                onTap: () {
                  final box = Hive.box<Products>('Products');
                  Iterable<Products> pj = box.values;
                  pj.forEach((element) {
                    element.orders = 0;
                    element.save();
                  });
                },
              ),
            ),
          ],
        ),
      ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                child: new ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _counter = 0;
                            });
                          },
                          child: Text("Deals",
                              style: TextStyle(
                                  fontSize: (_counter == 0) ? 20 : 15,
                                  color: (_counter == 0)
                                      ? Color.fromARGB(204, 182, 5, 5)
                                      : Colors.black))),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _counter = 1;
                            });
                          },
                          child: Text("Products",
                              style: TextStyle(
                                  fontSize: (_counter == 1) ? 20 : 15,
                                  color: (_counter == 1)
                                      ? Color.fromARGB(204, 182, 5, 5)
                                      : Colors.black))),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _counter = 2;
                            });
                          },
                          child: Text("Drinks",
                              style: TextStyle(
                                  fontSize: (_counter == 2) ? 20 : 15,
                                  color: (_counter == 2)
                                      ? Color.fromARGB(204, 182, 5, 5)
                                      : Colors.black)))
                    ])),
            Divider(
              thickness: 0.2,
              color: Colors.black,
            ),
            Container(
                height: _height * 0.75,
                child: WatchBoxBuilder(
                    box: Hive.box<Products>('Products'),
                    builder: ((context, box) {
                      Map<dynamic, dynamic> raw = box.toMap();
                      List list = raw.values.toList();

                      return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Products p = list[index];
                            if (p.type == Items[_counter]) {
                              return Producters(
                                  height: _height, width: _width, prods: p);
                            } else {
                              return SizedBox();
                            }
                          });
                    })))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: WatchBoxBuilder(
        box: Hive.box<Cart>('Cart'),
        builder: (context, box) {
          Cart raw = box.get(1);
          return Visibility(
            visible: raw.number == 0 ? false : true,
            child: Container(
              width: double
                  .infinity, // Set the width to the maximum available width
              height: _height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const checkout()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      139, 0, 0, 5), // Set the button's background color
                  onPrimary: Colors.white, // Set the button's text color
                  padding: EdgeInsets.all(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Checkout (${raw.number} items)",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "PKR ${raw.Total.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void Addprod(String name, String discription, int Price, String? Type) {
  final _product = Products()
    ..name = name
    ..description = discription
    ..Price = Price
    ..type = Type
    ..orders = 0;
  final box = Hive.box<Products>('Products');
  box.add(_product);
}

void Editprod(
    String name, String discription, int Price, String? Type, String prvname) {
  final box = Hive.box<Products>('Products');
  Iterable<Products> p = box.values.where((element) => element.name == prvname);
  Products result = p.first;
  result.name = name;
  result.description = discription;
  result.Price = Price;
  result.type = Type;
  result.save();
}

class Producters extends StatefulWidget {
  final double height, width;
  final Products prods;

  Producters({required this.height, required this.width, required this.prods});

  @override
  State<Producters> createState() => ProductState();
}

class ProductState extends State<Producters> {
  List<String> Items = ['Deals', 'Products', 'Drinks'];
  int addstate = 0;
  final _name = TextEditingController();
  final _dis = TextEditingController();
  final _price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _name.text = widget.prods.name;
    _dis.text = widget.prods.description;
    String prevname = _name.text;
    return InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Edit product'),
                  content: Form(
                      child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: TextFormField(
                            controller: _name,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Empty value not allowed';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: TextFormField(
                            controller: _dis,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Description'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: TextFormField(
                            controller: _price,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Price'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Empty value not allowed';
                              } else if (value == 0) {
                                return 'Mufte ka kuch ni milta';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: DropdownButtonFormField<String>(
                            value: Items[addstate],
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            onChanged: (String? values) {
                              setState(() {
                                if (values == 'Deals')
                                  addstate = 0;
                                else if (values == 'Products')
                                  addstate = 1;
                                else
                                  addstate = 2;
                              });
                            },
                            onSaved: (String? values) {
                              setState(() {
                                if (values == 'Deals')
                                  addstate = 0;
                                else if (values == 'Products')
                                  addstate = 1;
                                else
                                  addstate = 2;
                              });
                            },
                            items: Items.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Editprod(
                                      _name.text,
                                      _dis.text,
                                      int.parse(_price.text),
                                      Items[addstate],
                                      prevname);
                                },
                                child: Text('Edit')),
                            ElevatedButton(
                                onPressed: () {
                                  final box = Hive.box<Products>('Products');
                                  Iterable<Products> p = box.values.where(
                                      (element) =>
                                          element.name == widget.prods.name);
                                  Products result = p.first;
                                  result.delete();
                                },
                                child: Text('Delete'))
                          ],
                        )
                      ],
                    ),
                  )),
                );
              });
        },
        onTap: () {
          final box = Hive.box<Cart>('Cart');
          Cart? c = box.get(1);
          c?.number++;
          c?.Total += widget.prods.Price;
          c?.items.add(widget.prods);
          c?.save();
        },
        child: StaticCard(
            name: widget.prods.name,
            description: widget.prods.description,
            price: widget.prods.Price,
            orderNumber: widget.prods.orders)
        /*Card(
        color: Colors.white,
        elevation: 8,
        margin: EdgeInsets.all(10),
        shadowColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: widget.height * 0.12,
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.prods.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(widget.prods.description),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Orders: " + widget.prods.orders.toString(),
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 2, 20, 2),
              width: widget.width * 0.14,
              height: widget.height * 0.14,
              child: Center(
                child: Text(
                  "Rs \n" + widget.prods.Price.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),*/
        );
  }
}

class StaticCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final int orderNumber;

  StaticCard({
    required this.name,
    required this.description,
    required this.price,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(description),
                  SizedBox(height: 8),
                  Text('Order: $orderNumber'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\Rs. $price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
