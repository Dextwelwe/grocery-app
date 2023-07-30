import 'package:epicerie/models/grocery.dart';
import 'package:epicerie/models/item.dart';
import 'package:epicerie/services/grocery_service.dart';
import 'package:epicerie/services/items_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_item/add_item_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({Key? key}) : super(key: key);
  @override
 
  State<ItemsPage> createState() => _ItemsPage();
}

class _ItemsPage extends State<ItemsPage> {
  late GroceriesService service;
  late ItemService itemService;
  String? valueDropdown;
  String? valueCategory;
  String? qty;
  String categoryChoice = 'all';
  late List<Item> itemsFiltered =[];
  List<String> qtyList = 
  [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  @override
  void initState() {
    super.initState();
    service = Provider.of<GroceriesService>(context, listen: false);
    itemService = Provider.of<ItemService>(context, listen: false);
    itemsFiltered = itemService.items;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemService>(
      builder: (context, data, child) {
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
            child: SafeArea(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          iconTheme: const IconThemeData(color: Colors.black),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          )),
                          title: Text('Items',
                              style: TextStyle(
                                  fontFamily: GoogleFonts.cabin().fontFamily,
                                  color: Colors.black)),
                          backgroundColor: Colors.white70,
                          actions: <Widget>[
                            IconButton(
                              icon: const Center(
                                  child: Icon(
                                Icons.add,
                                color: Colors.black,
                              )),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddItemPage()),
                                ).then((value) => {setState(() {})})
                              },
                            ),
                          ],
                        ),
                        body: Column(children: [
                          Container(
                            height: constraints.maxHeight * 0.05,
                            alignment: Alignment.topLeft,
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              menuMaxHeight: constraints.maxHeight * 0.5,
                              hint: Text(
                                'Select grocery list',
                                style: TextStyle(
                                    color: Colors.teal.shade800,
                                    fontFamily: GoogleFonts.cabin().fontFamily,
                                    fontSize: 20),
                              ),
                              dropdownColor: Colors.teal.shade100,
                              onChanged: (value) {
                                setState(() {
                                  valueDropdown = value!;
                                });
                              },
                              items:
                                  service.listGroceries.map((Grocery grocery) {
                                return DropdownMenuItem(
                                  value: grocery.id,
                                  child: Text(
                                    grocery.name,
                                    style: TextStyle(
                                        color: Colors.teal.shade800,
                                        fontFamily:
                                            GoogleFonts.cabin().fontFamily,
                                        fontSize: 20),
                                  ),
                                );
                              }).toList(),
                              value: valueDropdown,
                            ),
                          ),
                          Container(
                            height: constraints.maxHeight * 0.05,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                DropdownButton(
                                  underline: const SizedBox(),
                                  dropdownColor: Colors.teal.shade100,
                                  menuMaxHeight: constraints.maxHeight * 0.5,
                                  hint: Text(
                                    'Search by Category',
                                    style: TextStyle(
                                        color: Colors.teal.shade800,
                                        fontFamily: GoogleFonts.cabin().fontFamily,
                                        fontSize: 20),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      valueCategory = value!;
                                      categoryChoice = valueCategory!;
                                      itemsFiltered = itemService.items
                                          .where((item) =>
                                              item.category == categoryChoice)
                                          .toList();
                                    });
                                  },
                                  items: data.items
                                      .map((item) => item.category)
                                      .toSet()
                                      .toList()
                                      .map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: Colors.teal.shade800,
                                            fontFamily:
                                                GoogleFonts.cabin().fontFamily,
                                            fontSize: 20),
                                      ),
                                    );
                                  }).toList(),
                                  value: valueCategory,
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.teal)
                                  ),
                                  onPressed: ()=> setState(() {
                                  valueCategory = null;
                                  itemsFiltered = itemService.items;
                                }), child: const Icon(Icons.highlight_remove_rounded))
                              ],
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth * 0.97,
                            height: constraints.maxHeight * 0.79,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white70,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.77,
                                  child: ListView.builder(
                                      itemCount: itemsFiltered.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Maker :${itemsFiltered[index].manufacturer}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          Text(
                                                            'Category :  ${itemsFiltered[index].manufacturer}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                                child: itemsFiltered[index]
                                                                            .urlImage !=
                                                                        ''
                                                                    ? Image.network(
                                                                        itemsFiltered[index]
                                                                            .urlImage)
                                                                    : const Text('')),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                                child: itemsFiltered[index]
                                                                            .urlNutritive !=
                                                                        ''
                                                                    ? Image.network(
                                                                        itemsFiltered[index]
                                                                            .urlNutritive)
                                                                    : const Text('')),
                                                          ),
                                                        ]),
                                                  ),
                                                  title: Text(
                                                      itemsFiltered[index]
                                                          .itemName),
                                                  backgroundColor:
                                                      Colors.teal.shade300,
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              color: Colors.teal.shade200,
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 5.0),
                                                title: Text(
                                                  itemsFiltered[index]
                                                      .manufacturer,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.teal.shade800,
                                                      fontFamily:
                                                          GoogleFonts.cabin()
                                                              .fontFamily,
                                                      fontSize: 20),
                                                ),
                                                subtitle: Text(
                                                    itemsFiltered[index]
                                                        .itemName),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    DropdownButton(
                                                      dropdownColor:
                                                          Colors.teal.shade100,
                                                      menuMaxHeight: constraints
                                                              .maxHeight *
                                                          0.5,
                                                      hint: Text(
                                                        'Qty',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .teal.shade800,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .cabin()
                                                                    .fontFamily,
                                                            fontSize: 20),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                        if (value == '0'){
                                                               itemsFiltered[
                                                                      index]
                                                                  .qty = null;
                                                                  itemsFiltered[
                                                                      index]
                                                                  .qtyList = null;
                                                        } else {
                                                           itemsFiltered[index].qty = value!;
                                                             itemsFiltered[
                                                                      index]
                                                                  .qtyList = value;
                                                        }
                                                        });
                                                      },
                                                      items: qtyList.map(
                                                          (String valueQty) {
                                                        return DropdownMenuItem(
                                                          value: valueQty,
                                                          child: Text(
                                                            valueQty,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal
                                                                    .shade800,
                                                                fontFamily: GoogleFonts
                                                                        .cabin()
                                                                    .fontFamily,
                                                                fontSize: 20),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      value:
                                                          itemsFiltered[index]
                                                              .qtyList,
                                                    ),
                                                    itemsFiltered[index].qty != null ?
                                                    IconButton(
                                                      icon: Center(
                                                          child:  Icon(
                                                        Icons.add, color: Colors
                                                            .teal.shade800,
                                                        size: 30,) 
                                                      ),
                                                      onPressed: () => setState(() {
                                                        itemsFiltered[index].qtyList = null;
                                                        if(valueDropdown != null){
                                                        addToGrocery(index);
                                                        const snackbar = SnackBar(content: Center(child: Text('added')));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                                        }else {
                                                          itemsFiltered[index].qty = null;
                                                          const snackbar = SnackBar(
                                                            content: Center(child: Text('Choose grocery list')));
                                                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                                        }
                                                      })
                                                      ,
                                                    ) : const SizedBox(),
                                                  ],
                                                ),
                                              )),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ])));
              },
            )));
      },
    );
  }
  void addToGrocery(index)async{
Grocery g = service.listGroceries.where((element) => element.id == valueDropdown).first;
List<dynamic> list =service.listGroceries.where((element) => element.id == valueDropdown).first.items;
    Item i = itemsFiltered[index];
    Item tmp;

  if (g.items.where((element) => element.code == itemsFiltered[index].code).isEmpty){
 list.add(i);
  }
  else 
  {
   tmp= g.items.firstWhere((element) => element.code == itemsFiltered[index].code);
      tmp.qty = ((tmp.qty!)); 
  }
service.updateAddedItemsGrocery(g.id);
  }
}
