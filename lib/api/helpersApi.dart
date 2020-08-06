import 'package:delevery_online/Model/about_us_model.dart';
import 'package:delevery_online/Model/add_order_model.dart';
import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/Model/service_model/final_page_model.dart';
import 'package:delevery_online/Model/service_model/product_service_model.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/Model/service_model/serviceModel.dart';
import 'package:delevery_online/Model/service_model/servixe_list_model.dart';
import 'package:delevery_online/Model/session.dart';
import 'package:delevery_online/Model/slider.dart';
import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/cart/addcartresult.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/cart/deleteFromCartModel.dart';
import 'package:delevery_online/exceptionStatus/all_exception.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'apiUtil.dart';

class HelpersApi {

  Map<String,String> headers = {
    'Accept':'application/json'
  };

  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';

  ////////////////////

  Future<List<SliderInfo>> getSliderData() async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'slider',
          'key_code' : '$key_Code'
        });
    switch(response.statusCode){
      case 200 :
        var body = jsonDecode(response.body);
        List<SliderInfo> data= [];
        for ( var item in body)
        {
          data.add(SliderInfo.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("slider");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }


    //return json.decode(response.body);
  }

  ///////////////////
  Future<Category> fetchCategoryInfo(String id) async {
    //  
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'category_info',
      'key_code': '$key_Code',
      'id': id
    });

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      Category categoryFetching = Category.fromJson(body);
      return categoryFetching;
    }
    return null;
  }
  ///////////////////
  Future<List<Category>> fetchCategories() async {
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'main_categories',
          'key_code' : '$key_Code'
        });
    switch(response.statusCode){
      case 200 :
        List<Category> data= [];
        var body = jsonDecode(response.body);
        for ( var item in body)
        {
          data.add(Category.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("categories");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }

  Future<Product> fetchPrdouctById(String id, String session_id) async {
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'product_info',
      'key_code': '$key_Code',
      'id': id,
      'session_id': session_id
    });
    switch (response.statusCode) {
      case 200:
        var body = jsonDecode(response.body);
        Product product = Product.fromJson(body);
//        setState(() {
//          productNew = product;
//        });
        return product;
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  Future<List<Category>> fetchRestaurantsCategories() async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'main_categories',
          'key_code' : '$key_Code',
          'category_type' : 'Restaurants'
        });
    switch(response.statusCode){
      case 200 :
        List<Category> data= [];
        var body = jsonDecode(response.body);
        for ( var item in body)
        {
          data.add(Category.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("categories");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }
  Future<List<Product>> fetchProductByCategoryId (String category_id ,String session_id )async{
    String url = ApiUtil.apiUrl;

    http.Response response = await http.post(url, body:
    {
      'action' : 'products_in_category',
      'key_code' : '$key_Code',
      'category_id' : category_id,
      'session_id' : session_id
    });

    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("products");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        List<Product> products = [];
        for(var item in body){
          products.add(Product.fromJson(item));
        }
        return products;
        break;
      default:
        return null ;
        break;
    }

  }
  Future<List<Product>> fetchFlowerByCategoryId (String category_id ,String session_id )async{
    

    String url = ApiUtil.apiUrl;

    http.Response response = await http.post(url, body:
    {
      'action' : 'products_in_category',
      'key_code' : '$key_Code',
      'category_id' : category_id,
      'session_id' : session_id
    });
    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("products");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        List<Product> products = [];
        for(var item in body){
          products.add(Product.fromJson(item));
        }
        return products;
        break;
      default:
        return null ;
        break;
    }

  }
  Future<List<CartModel>> fetchProductInCart (String session_id )async{
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body:
    {
      'action' : 'cart_content',
      'key_code' : '$key_Code',
      'session_id' : session_id
    });

    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("products");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        List<CartModel> cart = [];
        for(var item in body['result']){
          cart.add(CartModel.fromJson(item));
        }
        return cart;
        break;
      default:
        return null ;
        break;
    }

  }
  Future<DeleteFromCart> deleteProductFromCart (String session_id , String item_in_cart_id )async{
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body:
    {
      'action' : 'delete_from_cart',
      'key_code' : '$key_Code',
      'session_id' : session_id,
      'item_in_cart_id' : item_in_cart_id
    });

    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("delete Product From Cart");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        return DeleteFromCart.fromJson(body);
        break;
      default:
        return null ;
        break;
    }

  }




  Future<AddCartResult> sendToCart( String product_id , String quantity , String session_id ) async {
    
    String url = ApiUtil.mainUrl;
    var response = await http.post( url , body:
      {
        'action'     : 'add_to_cart',
        'key_code'   : '$key_Code',
        "product_id" : product_id,
        "quantity"   : quantity,
        "session_id" : session_id

      }
     );

    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("products");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        AddCartResult sessions = AddCartResult.fromJson(body);
        return sessions;
        break;
      default:
        return null ;
        break;
    }


  }
  Future<AddCartResult> editQuantityInCart(String product_id , String quantity , String session_id) async {
      
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'add_to_cart',
      'key_code': '$key_Code',
      'product_id' : product_id,
      'quantity' : quantity,
      'session_id' : session_id
    });
    switch (response.statusCode){
      case 200:
        var body = jsonDecode(response.body);
        AddCartResult cartModel = AddCartResult.fromJson(body);
//        setState(() {
//          cartModelResult = cartModel;
//        });
        return cartModel;
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }
  Future<AddCartResult> editQuantityInRestaurantsCart(String product_id , String quantity ) async {
      
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'update_product_quantity',
      'key_code': '$key_Code',
      'product_id' : product_id,
      'quantity' : quantity
    });
    switch (response.statusCode){
      case 200:
        var body = jsonDecode(response.body);
        AddCartResult cartModel = AddCartResult.fromJson(body);
        return cartModel;
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }
  // get list of unit
  Future<List<UnitModel>> getUnitsData() async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'unites',
          'key_code' : '$key_Code'
        });
    switch(response.statusCode){
      case 200 :
        final body = json.decode(response.body);
          List<UnitModel> data= [];
        for ( var item in body)
        {
            data.add(UnitModel.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("unit");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }


    //return json.decode(response.body);
  }

  // add new order
  Future<AddOrderModel> addNewOrderDio(String session_id , String order_type , List<Map <String,dynamic>> det , var pic )async{

    
    String url = ApiUtil.apiUrl;
    var body;
    if ( pic != null){
      String fileName = basename(pic.path);
      pic = await MultipartFile.fromFile(pic.path,filename: fileName);
      body = ({
        'action' : 'add_new_order',
        'key_code' : '$key_Code',
        'session_id' : session_id,
        'order_type' : order_type,
        'new_version' : "1",
        'details' : "$det",
        'pic' : pic
      });
    }else{
      pic = "";
      body = ({
        'action' : 'add_new_order',
        'key_code' : '$key_Code',
        'session_id' : session_id,
        'order_type' : order_type,
        'new_version' : "1",
        'details' : "$det",
        'pic' : pic
      });
    }
    try {
      FormData formData = new FormData.fromMap(body);
      Response response = await Dio().post(url, data: formData);
      switch(response.statusCode){
        case 404 :
          throw ResouceNotFound("Add New Order");
          break;
        case 301:
        case 302:
        case 303:
          throw RedirectionFound();
          break;
        case 200:
          var body = jsonDecode(response.data);
          return AddOrderModel.fromJson(body);
          break;
        default:
          return null ;
          break;
      }
    } catch (e) {
    }
  }

  // Home Services api

  Future<List<ServiceModel>> fetchHomeServiceCategories(String id) async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'service_categories',
          'key_code' : '$key_Code',
          'service_id' : id
        });
    switch(response.statusCode){
      case 200 :
        List<ServiceModel> data= [];
        var body = jsonDecode(response.body);
        for ( var item in body)
        {
          data.add(ServiceModel.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("categories");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }

  // fetch product in service

  Future<List<ProductServiceModel>> fetchProductByServiceId (String category_id ,String service_id )async{
    

    String url = ApiUtil.apiUrl;

    http.Response response = await http.post(url, body:
    {
      'action' : 'service_products',
      'key_code' : '$key_Code',
      'category_id' : category_id,
      'service_id' : service_id
    });


    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("products");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        List<ProductServiceModel> products = [];
        for(var item in body){
          products.add(ProductServiceModel.fromJson(item));
        }
        return products;
        break;
      default:
        return null ;
        break;
    }

  }

  // print Final Page

  Future<List<FinalPageModel>> printFinalPage ( String service_id )async{
    

    String url = ApiUtil.apiUrl;

    http.Response response = await http.post(url, body:
    {
      'action' : 'final_page',
      'key_code' : '$key_Code',
      'service_id' : service_id
    });

    switch(response.statusCode){
      case 404 :
        throw ResouceNotFound("final_Page");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      case 200:
        var body = jsonDecode(response.body);
        List<FinalPageModel> finalPageList = [];
        for(var item in body){
          finalPageList.add(FinalPageModel.fromJson(item));
        }
        return finalPageList;
        break;
      default:
        return null ;
        break;
    }

  }

  // Service List
  Future<List<ServiceListModel>> fetchServiceList() async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'services_in_menu',
          'key_code' : '$key_Code'
        });
    switch(response.statusCode){
      case 200 :
        List<ServiceListModel> data= [];
        var body = jsonDecode(response.body);
        for ( var item in body)
        {
          data.add(ServiceListModel.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("ServiceModel");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }

  // Search Model
  Future<List<SearchModel>> searchList(String session_id ,  String key_worlds) async {
    
    String url = ApiUtil.apiUrl ;
    http.Response response = await http.post(url,
        body: {
          'action': 'search',
          'key_code' : '$key_Code',
          'session_id' : session_id,
          'key_worlds' : key_worlds
        });
    switch(response.statusCode){
      case 200 :
        List<SearchModel> data= [];
        var body = jsonDecode(response.body);
        for ( var item in body)
        {
          data.add(SearchModel.fromJson(item));
        }
        return data;
        break;
      case 404 :
        throw ResouceNotFound("search");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }

  Future<Session> fetchSessionId() async {
//    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'generate_session_id',
      'key_code': '$key_Code',
      'product_id': ''
    });
    switch (response.statusCode) {
      case 200:
        try {
          var body = jsonDecode(response.body);
          Session sessions = Session.fromJson(body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('hasSessionId', sessions.result);
          return sessions;
        } catch (e) {
          return e;
        }
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  // fetch Main Setting
  Future<MainSetting> fetchMainSettings(String category) async {
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'main_settings',
      'new_version' : "1",
      'key_code': '$key_Code',
    });
    var body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        MainSetting mainSettingModel= MainSetting.fromJson(body);
        return mainSettingModel;
        break;
      case 404:
        throw ResouceNotFound('mainSetting');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  // fetch About Us
  Future<AboutUsModel> fetchAboutUs() async {
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'about',
      'key_code': '$key_Code',
    });
    var body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return AboutUsModel.fromJson(body);
        break;
      case 404:
        throw ResouceNotFound('mainSetting');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  // fetch Category
  /*
  Future<MainSetting> fetchMainSettings () async{
    
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url,
        body: {
          'action' : 'main_settings',
          'key_code' : '$key_Code',
        });
    var body = jsonDecode(response.body);
    switch(response.statusCode){
      case 200 :
        print("200 $body");
        return MainSetting.fromJson(body);
        break;
      case 404 :
        print("404 $body");
        throw ResouceNotFound("search");
        break;
      case 301:
      case 302:
      case 303:
      print("303 $body");
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

  }

   */


}





























/*
Future<List<ProductCategory>> fetchCategories(int page) async {
    
    String url = ApiUtil.CATEGORIES + '?page=' + page.toString();
    http.Response response = await http.get(url ,headers: headers);


    switch(response.statusCode){
      case 200 :
        List<ProductCategory> categories = [];
        var body = jsonDecode(response.body);
        for ( var item in body['data'])
        {
          categories.add(ProductCategory.fromJson(item));
        }
        return categories;
        break;
      case 404 :
        throw ResouceNotFound("categories");
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }

 */