import 'package:connectivity/connectivity.dart';
import 'package:epicerie/services/grocery_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/item.dart';

class GroceryListPage extends StatefulWidget {
  final String id;
  const GroceryListPage({Key? key, required this.id}) : super(key: key);
  @override
  State<GroceryListPage> createState() => _GroceryListPage();
}

class _GroceryListPage extends State<GroceryListPage> {
  int _selectedIndex = 0;
  bool isCompleted = false;
  late bool _hasInternet = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceriesService>(builder: (context, data, child) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromARGB(255, 153, 213, 213),
              Color.fromARGB(255, 76, 182, 182),
              Color.fromARGB(255, 0, 151, 151),
            ])),
        child: SafeArea(
          child: Scaffold(
              bottomNavigationBar: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BottomNavigationBar(
                    selectedItemColor: Colors.teal.shade600,
                    onTap: _onItemTapped,
                    currentIndex: _selectedIndex,
                    backgroundColor: Colors.white70,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.change_circle_outlined),
                        label: 'Active',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline),
                        label: 'Completed',
                      ),
                    ]),
              ),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                )),
                title: Text('Grocery List',
                    style: TextStyle(
                        fontFamily: GoogleFonts.cabin().fontFamily,
                        color: Colors.black)),
                backgroundColor: Colors.white70,
              ),
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                              height: constraints.maxHeight * 0.97,
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white70,
                              ),
                              child: ListView.builder(
                                  itemCount: data.listGroceries
                                      .where(
                                          (element) => element.id == widget.id)
                                      .first
                                      .items
                                      .length,
                                  itemBuilder: isCompleted
                                      ? (context, index) {
                                          Item i = data.listGroceries
                                              .where((element) =>
                                                  element.id == widget.id)
                                              .first
                                              .items[index];
                                          return i.status != ''
                                              ? ItemInfo(context, i, data)
                                              : const SizedBox();
                                        }
                                      : (context, index) {
                                          Item i = data.listGroceries
                                              .where((element) =>
                                                  element.id == widget.id)
                                              .first
                                              .items[index];
                                          return i.status == ''
                                              ? ItemInfo(context, i, data)
                                              : const SizedBox();
                                        })))
                    ]);
              })),
        ),
      );
    });
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      if (value == 1) {
        setState(() {
          isCompleted = true;
        });
      }
      if (value == 0) {
        setState(() {
          isCompleted = false;
        });
      }
    });
    //  provider.setViewGroceries(value);
  }

  // ignore: non_constant_identifier_names
  Dismissible ItemInfo(BuildContext context, Item i, GroceriesService service) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.green,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                "Completed",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "Not found",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            i.status = 'not found';
          });
          service.updateAddedItemsGrocery(widget.id);
        } else {
          setState(() {
            i.status = 'bought';
          });
          if (service.listGroceries
              .where((element) => element.id == widget.id)
              .first
              .isFavourite) {
            service.db.deleteAll();
            service.db.add(service.listGroceries
                .where((element) => element.id == widget.id)
                .first);
          }
          service.updateAddedItemsGrocery(widget.id);
        }
      },
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return _hasInternet == true
                  ? AlertDialog(
                      content: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Maker :${i.manufacturer}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Category :  ${i.category}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Center(
                                child: Container(
                                    child: i.urlImage != ''
                                        ? Image.network(i.urlImage)
                                        : const Text('')),
                              ),
                              Center(
                                child: Container(
                                    child: i.urlNutritive != ''
                                        ? Image.network(i.urlNutritive)
                                        : const Text('')),
                              ),
                            ]),
                      ),
                      title: Text(i.itemName),
                      backgroundColor: Colors.teal.shade300,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  : AlertDialog(content: const Text('NO INTERNET'), actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ]);
            }),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.teal.shade200,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            title: Text(
              i.manufacturer,
              style: TextStyle(
                  color: Colors.teal.shade800,
                  fontFamily: GoogleFonts.cabin().fontFamily,
                  fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i.itemName),
                Text(
                  i.status == '' ? '' : 'Status : ${i.status}',
                  style: TextStyle(
                      color: i.status == 'bought' ? Colors.green : Colors.red),
                )
              ],
            ),
            trailing: Text('QTY: ${i.qty}'),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}
