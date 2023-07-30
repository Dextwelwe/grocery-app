import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/item.dart';
import 'package:http/http.dart' as http;
class ItemService extends ChangeNotifier{
late List<Item> items = [];

ItemService(){
  getItems();
}

Future<void> addItem(Item item)async{
  try{
Map<String , dynamic> itemJson = item.toMap();
 CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('items');
  DocumentReference documentReference = await collectionReference.add(itemJson);
  String documentId = documentReference.id;
  item.id = documentId;
  items.add(item);
  } on Exception catch (e){
    if (kDebugMode) {
      print(e);
    }
    return;
  }
  notifyListeners();
}
Future<bool> addItemCupCode(String code)async {
  Item? item = await getItemFromApi(code);
  if (item!=null){
    if (items.where((element) => element.itemName == item.itemName && element.manufacturer == item.manufacturer).isNotEmpty)
    {return false;}else {
    addItem(item);
    return true;
    }
  }
  return false;
}

Future<Item?> getItemFromApi(String code)async{
   Item item;
   var url = Uri.parse('https://world.openfoodfacts.org/api/v2/search?code=$code');
  var response = await http.get(url);
   var body = jsonDecode(response.body);
   if ( body['count'] > 0){
   String manufacturer = body['products'][0]['brands'];
    String name = body['products'][0]['product_name'] ?? body['products'][0]['product_name_fr'];
    String category =(body['products'][0]['categories'] ??body['products'][0]['categories_properties_tags'][0] );
    String image =(body['products'][0]['image_front_url'] ?? '');
    String nutrition =(body['products'][0]['image_nutrition_url'] ?? '');
    if (category.contains(',')){
      category = category.substring(0, category.indexOf(','));
    }
    item = Item(name,  category, code, image, manufacturer);
    item.urlNutritive = nutrition;
    return item;
   }
    return null;
  }

Future<void> getItems()async{
List<DocumentSnapshot> documents = [];
QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('items').get();
 for (var doc in snapshot.docs) {
    documents.add(doc);
  }
if (documents.isNotEmpty){
for (int i =0; i< documents.length; i++){
   Item item = Item.fromMap(documents[i].data() as Map<String, dynamic>);
   Map<String, dynamic> map = documents[i].data() as Map<String, dynamic>;
   item.urlNutritive = map['url_nutritive'];
  item.id = documents[i].id;
  items.add(item);
  }
}
 notifyListeners();
}
}