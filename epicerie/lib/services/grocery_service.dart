import 'package:cloud_firestore/cloud_firestore.dart';
import  'package:epicerie/grocery_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/client.dart';
import '../models/grocery.dart';
import '../models/item.dart';

class GroceriesService extends ChangeNotifier{
late List<dynamic> listIdGroceries=[];
late List<Grocery> listGroceries = [];
bool isLoading = false;
Db db = Db();

Future<void> getGroceriesAuthUser() async{
isLoading = true;
 String? email = FirebaseAuth.instance.currentUser!.email;
   await FirebaseFirestore.instance.collection('users').where('email_address', isEqualTo: email).get().then((querySnapshot)  async {
  if (querySnapshot.docs.isNotEmpty){
  QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  Client client = Client.fromSnapshot(documentSnapshot);
 listIdGroceries = client.groceriesList;
 await getGroceriesInfo();
 listGroceries.sort((a, b) => b.isFavourite? 1 : 0.compareTo(a.isFavourite ? 1 : 0));
 }
  notifyListeners();
  isLoading = false;
 });

}

Future<void> getGroceriesInfo() async{
  List<DocumentSnapshot> documents = [];
  try {
  for (String id in listIdGroceries){
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('groceries').where(FieldPath.documentId, isEqualTo: id).get();
  if (snapshot.docs.isNotEmpty) {
    documents.add(snapshot.docs.first);
    }
  }
  for (int i =0; i< documents.length; i++){
   Grocery g = Grocery.fromMap(documents[i].data() as Map<String, dynamic>);
   g.id = documents[i].id;
   listGroceries.add(g);
  }
  } on Exception{ 
    return;
    }
    notifyListeners();
}

Future<void> addGrocery(Grocery grocery)async{
     CollectionReference collectionReference = FirebaseFirestore.instance.collection('groceries');
     DocumentReference documentReference = await collectionReference.add({"clients" : grocery.clients.map((e) => e.toMapSimple()).toList(), "completed":false, "date" : grocery.date, "isFavourite" : false, "items" :[], "name" : grocery.name});
     String documentId = documentReference.id;
     for (Client c in grocery.clients){
      Query userQuery = FirebaseFirestore.instance.collection('users').where('email_address', isEqualTo: c.emailAddress);
      await userQuery.get().then((querySnapshot) {
      if (querySnapshot.docs.length == 1) {
      DocumentReference userDocRef = querySnapshot.docs[0].reference;
      userDocRef.update({
      'grocery_lists': FieldValue.arrayUnion([documentId]),
    });
  } else {
    return;
  }
}).catchError((error) {
  if (kDebugMode) {
    print('Error querying database: $error');
  }
   return;
});}
    listIdGroceries.add(documentId);
    grocery.id = documentId;
    listGroceries.add(grocery);
    notifyListeners();
}

Future<void> getFavouriteGrocery() async {
  isLoading = true;
  listGroceries = await db.getFavouriteGrocery();
  notifyListeners();
  isLoading = false;
}

void updateAddedItemsGrocery(String idGrocery) async {
  final DocumentReference documentReference =  FirebaseFirestore.instance.collection('groceries').doc(idGrocery);
  List<Map<String, dynamic>> items = [];
  for(Item i in listGroceries.where((element) => element.id == idGrocery).first.items){
   items.add(i.toMapGrocery());
  }
   await documentReference.update({
     'items': items
   });
  notifyListeners();
  }

Future<void> updateFavouriteGroceryOfflineState() async{
  try {
  List<Grocery> grocery = await db.getFavouriteGrocery();
  if (grocery.isNotEmpty){
  final DocumentReference documentReference =  FirebaseFirestore.instance.collection('groceries').doc(grocery[0].id);
List<dynamic> groceries = grocery[0].itemsToMap();
   await documentReference.update({
      'items' : groceries,
      'isFavourite': grocery[0].isFavourite,
      'completed' : grocery[0].isCompleted,
   });
  }
  } catch (e){
    if (kDebugMode) {
      print(e);
    }
    return;
  }
  notifyListeners();
}

void removeFromFavourites(String id)async{
 final DocumentReference documentReference =  FirebaseFirestore.instance.collection('groceries').doc(id);
  await documentReference.update({
      'isFavourite': false
   });
   notifyListeners();
  }

  void updateCompleted(String idGrocery)async{
  final DocumentReference documentReference =  FirebaseFirestore.instance.collection('groceries').doc(idGrocery);
  DocumentSnapshot documentSnapshot = await documentReference.get();
 if (documentSnapshot.exists) {
   await documentReference.update({
   'completed' : true
   });
  }
  db.deleteAll();
  db.add(listGroceries.where((element) => element.id == idGrocery).first);
  }

void addToFavourites(bool isFavourite, int index){
bool favExists = false; 
String  idRemove = '' ;
for (int i =0; i< listGroceries.length ; i++){
  if (listGroceries[i].isFavourite == true && i != index){
    listGroceries[i].isFavourite = false;
    favExists = true;
    idRemove = listGroceries[i].id;
  }
}
 if (favExists){
    removeFromFavourites(idRemove);
    db.deleteAll();
  }
 db.add(listGroceries[index]);
listGroceries.sort((a, b) => b.isFavourite? 1 : 0.compareTo(a.isFavourite ? 1 : 0));
notifyListeners();
}

Future<void> getItemsbyGrocery(String groceryID)async {
 DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('groceries').doc(groceryID).get();
  if (snapshot.exists){
    var data = snapshot.data();
    listGroceries.where((element) => element.id == groceryID).first.items = fromMapItems(data!['items']);
  }
  notifyListeners();
}

 static List<Item> fromMapItems(List<dynamic> data){
    List<Item> items = [];
    for(int i=0; i<data.length; i++){
      items.add(Item(data[i]['item_name'], data[i]['category'], data[i]['code'], data[i]['img_url'], data[i]['manufacturer']));
      items[i].qty = data[i]['qty'];
      items[i].urlNutritive = data[i]['url_nutritive'] ?? '';
      items[i].status = data[i]['status'] ?? '';
    }
    return items;
  }

Future<void> getGroceries(bool isConnected)  async {

if (isConnected){
 updateFavouriteGroceryOfflineState();
 getGroceriesAuthUser();
}else{
getFavouriteGrocery();
}
}


void clearArrays(){
  listGroceries = [];
  listIdGroceries = [];
}
}