class Item {
late String id = '';
late String itemName;
late String category;
late String code ='';
late String urlImage;
late String manufacturer;
late String urlNutritive='';
String? qty ;
String? qtyList;
late String status ='';

Item(this.itemName, this.category, this.code, this.urlImage, this.manufacturer);

 Map<String, dynamic> toMap(){
  return {
    'item_name' : itemName,
    'category' : category,
    'code' : code,
    'img_url' : urlImage,
    'manufacturer' : manufacturer,
    'url_nutritive' : urlNutritive,
  };
}

 Map<String, dynamic> toMapGrocery(){
  return {
    "item_name" : itemName,
    'category' : category,
    'code' : code,
    'img_url' : urlImage,
    'manufacturer' : manufacturer,
    'url_nutritive' : urlNutritive,
    'qty' : qty,
    'status' : status
  };
}

factory Item.fromMap(Map<String, dynamic> data){
  return Item(data['item_name'],  data['category'], data['code'], data['img_url'], data['manufacturer']);
}
}