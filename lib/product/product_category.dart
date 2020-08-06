import 'package:delevery_online/exceptionStatus/all_exception.dart';

class ProductCategory{
  int id;
    String title;
  //  String image_direction;
    String pic;

  ProductCategory(this.id, this.title, this.pic);

  ProductCategory.fromJson(Map<String,dynamic> jsonObject){
    assert (jsonObject['id']== null , "id is null");
    assert (jsonObject['title']== null , "title is null");
    //assert (jsonObject['image_direction']== null , "image_direction is null");
    assert (jsonObject['pic']== null , "pic is null");

    if ( jsonObject['id'] == null){
      throw PropertyIsRequired("id");
    }
    if ( jsonObject['title'] == null){
      throw PropertyIsRequired("title");
    }
//    if ( jsonObject['image_direction'] == null){
//      throw PropertyIsRequired("image_direction");
//    }
    if ( jsonObject['pic'] == null){
      throw PropertyIsRequired("pic");
    }

    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
  //  this.image_direction = jsonObject['image_direction'];
    this.pic = jsonObject['pic'];
  }


}