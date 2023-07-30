// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final List<dynamic> groceriesList;

  Client({required this.firstName, required this.lastName,required this.emailAddress,required this.groceriesList});

  factory Client.fromSnapshot(DocumentSnapshot documentSnapshot){
    return Client(
      firstName : documentSnapshot['first_name'],
      lastName : documentSnapshot['last_name'],
      emailAddress : documentSnapshot['email_address'],
      groceriesList : documentSnapshot['grocery_lists']
    );
  }
  Map<String,dynamic> toMap(){
    return {
    'first_name' : firstName,
    'last_name' : lastName,
    'email_address' : emailAddress,
    'grocery_list' : groceriesList
    };
  }

  Map<String,dynamic> toMapSimple(){
     return {
    'first_name' : firstName,
    'last_name' : lastName,
    'email_address' : emailAddress,
    };
  }
}