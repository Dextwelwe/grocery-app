import 'package:epicerie/services/client_service.dart';
import 'package:epicerie/services/grocery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/client.dart';
import 'models/grocery.dart';

class AddGroceryList extends StatefulWidget {
  const AddGroceryList({Key? key}) : super(key: key);
  @override
  
  State<AddGroceryList> createState() => _AddGroceryList();
}

class _AddGroceryList extends State<AddGroceryList> {
  late Grocery grocery = Grocery('', nameController.text.trim(), DateTime.now().toIso8601String(), [], false, [], false);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  List<Client> groceriesList = [];
  DateTime? dateGrocery;
  String messageErr = '';
  String messageAddClient = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<GroceriesService> (builder : (context, data, child) {
      return Scaffold(
          body: Container(
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
                child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Form(
                              child: Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.teal.shade100,
                                      ),
                                      width: constraints.maxWidth * 0.95,
                                      child: Column(children: <Widget>[
                                        SizedBox(
                                          height: constraints.maxHeight * 0.01,
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.85,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.teal),
                                                ),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.teal),
                                                ),
                                                labelText: 'Name',
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        GoogleFonts.cabin()
                                                            .fontFamily)),
                                            controller: nameController,
                                            textInputAction: TextInputAction.next,
                                          ),
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.85,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: constraints.maxWidth *
                                                      0.85 *
                                                      0.50,
                                                  child: Text(
                                                    "Grocery date",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            GoogleFonts.cabin()
                                                                .fontFamily),
                                                  )),
                                              SizedBox(
                                                width: constraints.maxWidth *
                                                    0.85 *
                                                    0.50,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<
                                                                Color>(
                                                            Colors.teal.shade300),
                                                  ),
                                                  onPressed: () {
                                                    DatePicker.showDatePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        minTime: DateTime.now(),
                                                        onChanged: (date) {},
                                                        onConfirm: (date) {
                                                      setState(() {
                                                        dateGrocery = date;
                                                        grocery.date = date.toIso8601String();
                                                      });
                                                    },
                                                        currentTime:
                                                            DateTime.now());
                                                            
                                                  },
                                                  child: (dateGrocery == null)
                                                      ? const Text(
                                                          'Grocery date',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          DateFormat(
                                                                  'dd-MMMM-yyyy')
                                                              .format(
                                                                  dateGrocery!),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.85,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: constraints.maxWidth *
                                                    0.85 *
                                                    0.83,
                                                child: TextField(
                                                  cursorColor: Colors.teal,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.teal),
                                                      ),
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.teal),
                                                      ),
                                                      labelText:
                                                          'Add member (optional)',
                                                      hintText: 'Email',
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              GoogleFonts.cabin()
                                                                  .fontFamily)),
                                                  controller: emailController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                ),
                                              ),
                                              SizedBox(
                                                width: constraints.maxWidth *
                                                    0.85 *
                                                    0.17,
                                                child: ElevatedButton(
                                                  onPressed: addMember,
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .teal
                                                                  .shade300)),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.add),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: Text(
                                            
                                            messageErr,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.5,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if ( await addGrocery(data)){
                                              if (context.mounted)  Navigator.pop(context);
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.teal.shade300)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.add),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Create grocery",
                                                    style: TextStyle(
                                                      fontSize:
                                                          (constraints.maxWidth *
                                                              0.5 *
                                                              0.09),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: constraints.maxHeight * 0.01,),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.5,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.teal.shade300)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.arrow_back),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Back",
                                                    style: TextStyle(
                                                      fontSize:
                                                          (constraints.maxWidth *
                                                              0.5 *
                                                              0.09),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                         SizedBox(height: constraints.maxHeight * 0.01,)
                                      ]))),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.01,
                            ),
                            Container(
                                child: groceriesList.isNotEmpty
                                    ? Container(
                                        width: constraints.maxWidth * 0.95,
                                        height: constraints.maxHeight * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.teal.shade100,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Added members',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: GoogleFonts.cabin()
                                                      .fontFamily),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      groceriesList.length,
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                        '${groceriesList[index].firstName} ${groceriesList[index].lastName}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .cabin()
                                                                    .fontFamily),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ))
                                    : const Text('')),
                            SizedBox(
                              height: constraints.maxHeight * 0.01,
                            ),
                          ])));
                }),
              )));
  });
  }

  bool validationInput() {
    if (nameController.text.isEmpty) {
      setState(() {
        messageErr = 'Field(s) are empty';
      });
      return false;
    }
    if (dateGrocery == null) {
      setState(() {
        messageErr = 'Select date';
      });
      return false;
    }

    if (emailController.text.isNotEmpty && !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text.trim())) {
      setState(() {
        messageErr = 'Email is invalid';
      });
      return false;
    }
    return true;
  }

  void addMember() async {
    User? user = FirebaseAuth.instance.currentUser;
    ClientService clientService = ClientService();
    Client client =
        await clientService.getClientByEmail(emailController.text.trim());
    List<dynamic> clientDuplicate = grocery.clients
        .where((element) => element.emailAddress == emailController.text.trim())
        .toList();
        if (emailController.text.trim() ==  user!.email){
           setState(() {
        messageErr = 'You can\'t add yourself';
        return;
      });
        }
    else if (client.firstName != '' && clientDuplicate.isEmpty) {
      setState(() {
        if (client.emailAddress != user.email){
          groceriesList.add(client);
        }
        grocery.clients.add(client);
        messageAddClient = '';
      });
    } else {
      setState(() {
        messageErr = 'This client doesn\'t exist or already added';
      });
    }
  }

  Future<bool> addGrocery(GroceriesService data) async {  
    ClientService clientService = ClientService();
    if (validationInput()) {
    grocery.clients.add(await clientService.getClientByEmail(FirebaseAuth.instance.currentUser!.email.toString()));
    data.addGrocery(grocery);
    return true;
    }
    return false;
  }
}