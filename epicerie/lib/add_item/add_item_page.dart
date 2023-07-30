import 'package:epicerie/models/item.dart';
import 'package:epicerie/services/items_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPage();
}

class _AddItemPage extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemService>(builder: (context, data, child) {
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
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.75,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.teal.shade400)),
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddItem(manual: true)))
                                    },
                                child: Text('Add item manually',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.cabin().fontFamily,
                                        color: Colors.white,
                                        fontSize: 20))),
                          ),
                          SizedBox(
                              width: constraints.maxWidth * 0.75,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.teal.shade400)),
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddItem(manual: false)))
                                },
                                child: Text('Scan CUP code',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.cabin().fontFamily,
                                        color: Colors.white,
                                        fontSize: 20)),
                              )),
                          SizedBox(
                              width: constraints.maxWidth * 0.75,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.teal.shade400)),
                                onPressed: () => {Navigator.of(context).pop()},
                                child: Text('Back',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.cabin().fontFamily,
                                        color: Colors.white,
                                        fontSize: 20)),
                              ))
                        ],
                      ),
                    )));
          })));
    });
  }
}

class AddItem extends StatelessWidget {
  final bool manual;
  const AddItem({required this.manual, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.transparent,
                body: manual ? const AddManually() : const AddCup(),
              ));
        })));
  }
}

class AddCup extends StatefulWidget {
  const AddCup({
    super.key,
  });

  @override
  State<AddCup> createState() => _AddCupState();
}

class _AddCupState extends State<AddCup> {
  @override
  void initState() {
    super.initState();
  }

  String result = '';
  late ItemService itemService;

  @override
  Widget build(BuildContext context) {
    itemService = Provider.of<ItemService>(context, listen: false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.teal.shade500),
            ),
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              if (res != '-1') {
                if (await itemService.addItemCupCode(res)) {
                  setState(() {
                    result = 'saved';
                  });
                } else {
                  setState(() {
                    result = 'Not saved';
                  });
                }
              }
            },
            child: const Text('Open Scanner'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.teal.shade500),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Back'),
          ),
          Text(result)
        ],
      ),
    );
  }
}

class AddManually extends StatefulWidget {
  const AddManually({Key? key}) : super(key: key);
  @override
 State<AddManually> createState() => _AddManually();
}

class _AddManually extends State<AddManually> {
  final _itemNameController = TextEditingController();
  final _cupController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _itemCategoryController = TextEditingController();
  late String validationMessage = '';
  late ItemService itemService;

  @override
  void dispose() {
    _itemNameController.dispose();
    _cupController.dispose();
    _itemCategoryController.dispose();
    _manufacturerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    itemService = Provider.of<ItemService>(context, listen: false);
    _cupController.text = '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.teal.shade100,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    iconColor: Colors.teal,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade700),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    labelText: 'Item Name',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.cabin().fontFamily),
                  ),
                ),
                TextField(
                  controller: _itemCategoryController,
                  decoration: InputDecoration(
                    iconColor: Colors.teal,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade700),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    labelText: 'Category',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.cabin().fontFamily),
                  ),
                ),
                TextField(
                  controller: _manufacturerController,
                  decoration: InputDecoration(
                    iconColor: Colors.teal,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade700),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    labelText: 'Manufacturer',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.cabin().fontFamily),
                  ),
                ),
                TextField(
                  controller: _cupController,
                  decoration: InputDecoration(
                    iconColor: Colors.teal,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade700),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    labelText: 'Cup code (optional)',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.cabin().fontFamily),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      validationMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    )),
                  ),
                ),
                SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          if (addItem()) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.teal.shade300)),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ]))),
                SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.teal.shade300)),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ])))
              ],
            ),
          ),
        )),
      ],
    );
  }

  bool validateControllers() {
    List<TextEditingController> controllers = [
      _itemCategoryController,
      _itemNameController,
      _manufacturerController
    ];
    // ignore: non_constant_identifier_names
    int field_counter = 0;
    for (int i = 0; i < 3; i++) {
      if (controllers[i].text.trim().isEmpty) {
        field_counter++;
      }
    }
    if (field_counter > 1) {
      setState(() {
        validationMessage = 'Fields are empty';
      });
      return false;
    }

    if (_itemCategoryController.text.trim().isEmpty) {
      setState(() {
        validationMessage = 'Category field is empty';
      });
      return false;
    }
    if (_itemNameController.text.trim().isEmpty) {
      setState(() {
        validationMessage = 'Name field is empty';
      });
      return false;
    }
    if (_manufacturerController.text.trim().isEmpty) {
      setState(() {
        validationMessage = 'Weight field is empty';
      });
      return false;
    }
    return true;
  }

  bool addItem() {
    if (validateControllers()) {
      itemService.addItem(Item(
          _itemNameController.text.trim(),
          _itemCategoryController.text.toLowerCase().replaceRange(
              0, 1, _itemCategoryController.text.trim()[0].toUpperCase()),
          _cupController.text.trim(),
          '',
          _manufacturerController.text.trim()));
      return true;
    }
    return false;
  }
}
