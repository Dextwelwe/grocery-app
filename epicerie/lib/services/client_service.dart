import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';

class ClientService{

Future<Client> getClientByEmail(String email) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('email_address', isEqualTo: email)
      .limit(1)
      .get();

  if (result.docs.isNotEmpty) {
    var data = result.docs.first;
    Client client = Client(firstName : data['first_name'], lastName: data['last_name'],emailAddress: data['email_address'],groceriesList: data['grocery_lists']);
    return client;
  } else {
    Client client = Client(firstName: '',lastName: '',emailAddress: '',groceriesList: ['']);
    return client;
  }
}
}