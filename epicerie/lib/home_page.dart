import 'package:connectivity/connectivity.dart';
import 'package:epicerie/grocery_list_page.dart';
import 'package:epicerie/items_page.dart';
import 'package:epicerie/services/grocery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_grocery_list.dart';
import 'grocery_db.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late GroceriesService provider;
  late bool _hasInternet = false;
  bool isCompleted = true;
  int _selectedIndex = 0;
  @override
  void initState() {
    if (mounted) {
      super.initState();
      provider = Provider.of<GroceriesService>(context, listen: false);
      _checkConnectivity();
      provider.getGroceries(_hasInternet);
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        setState(() {
          _hasInternet = result != ConnectivityResult.none;
          provider.clearArrays();
          provider.getGroceries(_hasInternet);
        });
      });
    }
  }

  @override 
  dispose(){
    super.dispose();
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
      return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: floatingActionButtonHomePage(context),
          appBar: appBarHomePage(context),
          bottomNavigationBar: bottomNavigationBarHomePage(),
          body: data.isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
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
                            child:            
                             data.listGroceries.isNotEmpty
                                ? ListView.builder(
                                    itemCount: data.listGroceries.length,
                                    itemBuilder: (context, index) {
                                      final item = data.listGroceries[index];
                                      if (item.isCompleted == isCompleted) {
                                        return const SizedBox();
                                      }
                                      return !item.isCompleted && _hasInternet
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Dismissible(
                                                background: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    color: Colors.teal.shade300,
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text('Completed',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15)),
                                                    )),
                                                key: Key(item.id),
                                                direction:
                                                    DismissDirection.endToStart,
                                                onDismissed: (direction) {
                                                  setState(() {
                                                    item.isCompleted = true;
                                                    data.updateCompleted(
                                                        item.id);
                                                  });
                                                },
                                                child: grocery(data, index),
                                              ),
                                            )
                                          : grocery(data, index);
                                    })
                                : Center(
                                    child: Text(
                                      'No groceries',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily:
                                              GoogleFonts.cabin().fontFamily,
                                          fontSize: 20),
                                    ),
                                  ),
                          ),
                        
                        )
              ]);
                }
                ),
                );
                
    });
  }

  ClipRRect bottomNavigationBarHomePage() {
    return ClipRRect(
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
    );
  }

  AppBar appBarHomePage(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      )),
      title: Text('Groceries',
          style: TextStyle(
              fontFamily: GoogleFonts.cabin().fontFamily, color: Colors.black)),
      backgroundColor: Colors.white70,
      actions: <Widget>[
        Center(
            child: Theme(
          data: Theme.of(context).copyWith(cardColor: Colors.white),
          child: PopupMenuButton<String>(onSelected: (value) {
            
            singOut();
          }, itemBuilder: (BuildContext context) {
            return {'Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          }),
        ))
      ],
    );
  }

  Visibility floatingActionButtonHomePage(BuildContext context) {
    return Visibility(
      visible: _hasInternet,
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ItemsPage()),
                )
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddGroceryList()),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector grocery(GroceriesService data, int index) {
    return GestureDetector(
      onTap: () {
        data.getItemsbyGrocery(data.listGroceries[index].id);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GroceryListPage(id: data.listGroceries[index].id)),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.teal.shade200,
          child: ListTile(
            leading: data.listGroceries[index].clients.length == 1
                ? const Icon(
                    Icons.person,
                    size: 50,
                  )
                : const Icon(
                    Icons.people,
                    size: 50,
                  ),
            title: Text(
              data.listGroceries[index].name,
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              'grocery date : ${DateFormat('dd-MMMM-yyyy').format(DateTime.parse(data.listGroceries[index].date))}',
            ),
            trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    data.listGroceries[index].isFavourite =
                        !data.listGroceries[index].isFavourite;
                    addToFavourites(
                        data, data.listGroceries[index].isFavourite, index);
                  });
                },
                child: data.listGroceries[index].isFavourite == false
                    ? const Icon(
                        Icons.star_border_outlined,
                        size: 30,
                      )
                    : const Icon(
                        Icons.star,
                        size: 30,
                      )),
          )),
    );
  }

  void singOut() {
     Db db = Db();
     db.deleteAll();
    provider.clearArrays();
    FirebaseAuth.instance.signOut();
  }

  void addToFavourites(GroceriesService data, bool isFav, int index) {
    if (isFav) {
      data.addToFavourites(isFav, index);
    } else {
      data.removeFromFavourites(data.listGroceries[index].id);
      data.db.deleteAll();
    }
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      if (value == 1) {
        setState(() {
          isCompleted = false;
        });
      }
      if (value == 0) {
        setState(() {
          isCompleted = true;
        });
      }
    });
  }
}
