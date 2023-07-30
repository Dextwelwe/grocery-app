import 'dart:convert';
import 'package:epicerie/models/item.dart';
import 'client.dart';

class Grocery {
late  String id;
late  String name;
late  String date;
late List<dynamic> items;
late  bool isCompleted;
late  List<dynamic> clients;
late  bool isFavourite;

Grocery(this.id, this.name, this.date, this.items, this.isCompleted, this.clients, this.isFavourite);

factory Grocery.fromMap(Map<String, dynamic> data){
return Grocery('0',data["name"], data["date"], fromMapItems(data['items']), data["completed"], fromMapClients(data["clients"]), data["isFavourite"]);
}

factory Grocery.fromDatabase(Map<String , dynamic> data){
  return Grocery(data['id'],data['name'], data["date"], fromMapItems(jsonDecode(data['items'])), data['completed'] == 1 ? true : false, fromMapClients(jsonDecode(data['clients'])), data['favourite'] == 1? true : false);
 }


   List<dynamic> clientsToMap (){
   List<dynamic>  clients1 = [] ;
   for (int i =0; i< clients.length; i++){
    clients1.add({
      'first_name' : clients[i].firstName,
      'last_name' : clients[i].lastName,
      'email_address' : clients[i].emailAddress
    });
  }
  return clients1;
  }

  List<dynamic> itemsToMap(){
    List<dynamic> items1 = [];
    for (int i=0; i < items.length; i++){
      items1.add({
       "item_name" : items[i].itemName,
    'category' : items[i].category,
    'code' : items[i].code,
    'img_url' : items[i].urlImage,
    'manufacturer' : items[i].manufacturer,
    'url_nutritive' : items[i].urlNutritive,
    'qty' :items[i].qty,
    'status' : items[i].status
    });
    }
    return items1;
  }
  
  Map<String, dynamic> toMap() {
  return {
    'id' : id,
    'name' : name,
    'date' : date,
    'items' : jsonEncode(itemsToMap()),
    'completed' : isCompleted == true ? 1 : 0,
    'clients' : jsonEncode(clientsToMap()) ,
    'favourite' : isFavourite == true ? 1 : 0
  };
 }

static List<Client> fromMapClients(List<dynamic> data){
List<Client> clients =[];
for (int i=0; i< data.length ; i++) {
clients.add(Client(firstName: data[i]['first_name'], lastName: data[i]['last_name'], emailAddress: data[i]['email_address'], groceriesList: []));
}
return clients;
}

static List<Item> fromMapItems(List<dynamic>data){
  List<Item> items1 = [];
  for (int i=0; i< data.length ; i++) {
items1.add(Item(data[i]['item_name'], data[i]['category'],data[i]['code'], data[i]['img_url'], data[i]['manufacturer']));
items1[i].qty = data[i]['qty'];
items1[i].urlNutritive = data[i]['url_nutritive'];
items1[i].status = data[i]['status'] ?? '';
  }
  return items1;
}
}