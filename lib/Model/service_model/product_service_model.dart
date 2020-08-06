import 'package:flutter/material.dart';

class ProductServiceModel{
  String id ;
  String pic;
  String title , description;
  String price ;
  String quantity_type;
  String category_id;
  String service_id;
  bool   price_visible;
  ValueNotifier<String> valueNotifier = ValueNotifier("0.0");
  double startServiceQuantityValue = 0.0;

  ProductServiceModel({this.id,this.pic, this.title, this.description,this.price_visible, this.price,
    this.quantity_type, this.category_id ,this.service_id , this.startServiceQuantityValue , this.valueNotifier});

  ProductServiceModel.fromJson( Map<dynamic,dynamic> jsonObject ){
    this.pic = jsonObject['pic'];
    this.title = jsonObject['title'];
    this.description = jsonObject['description'];
    this.price = jsonObject['price'];
    this.price_visible = jsonObject['price_visible'];
    this.quantity_type = jsonObject['quantity_type'];
    this.category_id = jsonObject['category_id'];
    this.id = jsonObject['id'];
    this.service_id = jsonObject['service_id'];

  }
  String feuatredImage(){
    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7nJB8g29IeZ31DK7JCuowgeYwl87NyGAI-fgTdTPmr4PT6A1ZDg";
  }

}