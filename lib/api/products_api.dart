//import 'dart:convert';
//
//import 'package:delevery_online_test1/Model/product.dart';
//import 'package:delevery_online_test1/exceptionStatus/all_exception.dart';
//import 'package:delevery_online_test1/product/product.dart';
//import 'apiUtil.dart';
//import 'package:http/http.dart' as http;
//
//
//class ProductsApi{
//
//  Map<String,String> headers ={
//    'Accept' : 'application/json'
//  };
//
//
//  Future<List<ProductEcommerce>> fetchProduct (int page )async{
//    await checkInternet();
//
//    String url = ApiUtil.PRODUCTS +'?page=' + page.toString();
//
//    http.Response response = await http.get(url, headers: headers);
//
//
//    List<ProductEcommerce> products = [];
//    if(response.statusCode == 200){
//      var body = jsonDecode(response.body);
//      for(var item in body['data']){
//        products.add(ProductEcommerce.fromJson(item));
//      }
//      return products;
//    }
//    return null;
//  }
//
//// Future<List<Product>> fetchProductByCategories (String category_id)async{
////   await checkInternet();
//
////   String url = ApiUtil.apiUrl;
//
////   http.Response response = await http.post(url, body:
////   {
////     'action' : 'products_in_category',
////     'key_code' : '7bea9fe7d1bffe42150e13893d5ad971',
////     'category_id' : category_id
//
////   });
//
////   List<Product> products = [];
//
////   switch(response.statusCode){
////     case 404 :
////       throw ResouceNotFound("products");
////       break;
////     case 301:
////     case 302:
////     case 303:
////       throw RedirectionFound();
////       break;
////     case 200:
////       var body = jsonDecode(response.body);
////       for(var item in body){
////         products.add(Product.fromJson(item));
////       }
////       return products;
////       break;
////     default:
////       return null ;
////       break;
////   }
//
//// }
//
//
//  Future<ProductEcommerce> fetchPrdouctById (int product_id)async{
//    await checkInternet();
//    String url = ApiUtil.PRODUCT + product_id.toString();
//    http.Response response = await http.get(url,headers: headers);
//    if (response.statusCode == 200){
//      var body = jsonDecode(response.body);
//      return ProductEcommerce.fromJson(body['data']);
//    } return null;
//
//  }
//
//}