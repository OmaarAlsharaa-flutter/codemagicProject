

import 'package:delevery_online/exceptionStatus/all_exception.dart';

class SliderInfo {

  String id;
  String title;
  String pic;
  String link;
  String category_id;
  String product_id;

  SliderInfo(this.id, this.title, this.pic,
      { this.link, this.category_id, this.product_id});

  SliderInfo.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
    this.pic = jsonObject['pic'];
    this.link = jsonObject['link'];
    this.category_id = jsonObject['category_id'];
    this.product_id = jsonObject['product_id'];

    if (jsonObject['id'] == null) {
      throw PropertyIsRequired("id");
    }
    if (jsonObject['title'] == null) {
      throw PropertyIsRequired("title");
    }
    if (jsonObject['pic'] == null) {
      throw PropertyIsRequired("pic");
    }
    if (jsonObject['link'] == null) {
      throw PropertyIsRequired("link");
    }
    if (jsonObject['category_id'] == null) {
      throw PropertyIsRequired("category_id");
    }
    if (jsonObject['product_id'] == null) {
      throw PropertyIsRequired("product_id");
    }

 // this.category_id = [];
 // if (jsonObject['category_id'] != null) {
 //   _setCategory(jsonObject['category_id']);
 // }

 // this.product_id = [];
 // if (jsonObject['product_id'] != null) {
 //   _setProduct(jsonObject['product_id']);
 // }
  }

 // void _setProduct(List<dynamic> jsonProduct) {
 //   this.product_id = [];
 //   if (jsonProduct.length > 0) {
 //     for (var item in jsonProduct) {
 //       if (item != null) {
 //         product_id.add(Product.fromJson(item));
 //       }
 //     }
 //   }
 // }
//
 // void _setCategory(List<dynamic> jsonCategory) {
 //   this.category_id = [];
 //   if (jsonCategory.length > 0) {
 //     for (var item in jsonCategory) {
 //       if (item != null) {
 //         category_id.add(Category.fromJson(item));
 //       }
 //     }
 //   }
 // }

}


    //  this.product_total = double.tryParse(jsonObject['product_total']);
    //  this.product_discount = double.tryParse(jsonObject['product_discount']);
 //   this.category = Category.fromJson(jsonObject['product_category']);

