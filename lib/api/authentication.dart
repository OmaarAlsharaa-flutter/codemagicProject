//import 'package:ecommerce/customer/user.dart';
//import 'package:ecommerce/exceptionStatus/all_exception.dart';
//import 'package:http/http.dart' as http;
//import 'apiUtil.dart';
//import 'dart:convert';
//
//class Authentication {
//
//
//  Future<User> register (String first_name ,String last_name ,String email ,String password)async{
//    await checkInternet();
//    String register_api = ApiUtil.AUTH_REGISTER;
//
//    Map<String,String> headers = {
//      'Accept':'application/json'
//    };
//
//    Map<String,String> body = {
//      'first_name':first_name,
//      'last_name':last_name,
//      'email':email,
//      'password':password
//
//    };
//
//    http.Response response = await http.post(register_api , headers: headers,body: body);
//
//    switch(response.statusCode){
//      case 200 :
//        var body = jsonDecode(response.body);
//        var data = body["data"];
//        User user = User.fromJson(data);
//        return user;
//        break;
//      case 402 :
//        throw UnProcessedEntitiy;
//        break;
//      default :
//        return null ;
//        break;
//
//    }
//
//  }
//
//
//  Future<User> login(String email , String password) async{
//
//    await checkInternet();
//    String login_api = ApiUtil.AUTH_LOGIN;
//    Map<String,String> headers = {
//      'Accept':'application/json'
//    };
//    Map<String,String> body = {
//      'email':email,
//      'password':password
//
//    };
//
//    print("Ready");
//    http.Response response = await http.post(login_api,headers: headers,body: body);
//    print(response.statusCode);
//    switch(response.statusCode){
//      case 200 :
//        var body = jsonDecode(response.body);
//        var data = body["data"];
//        print(data);
//        User user = User.fromJson(data);
//        return user;
//        break;
//      case 404:
//        throw ResouceNotFound("User");
//        break;
//      case 401:
//        throw LoginFailed;
//      default :
//        return null;
//        break;
//
//    }
//  }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
///*
/////////////////////// Json Format Register /////////////////////////
//
//{
//  "data":{
//  "first_name":"ahmad"
//  "last_name":"ssss"
//  "email":"ahmad"
//  "password":"ahmad"
//
//  }
//}
//
//
//////////////////////////////////////////////////////
//
// */
//
//
///*
/////////////////////// Json Format Login /////////////////////////
//
//{
//  "data":{
//  "user_id":"ahmad"
//  "first_name":"ahmad"
//  "last_name":"ssss"
//  "email":"ahmad"
//  "api_token":"dsdakjsdklasdi8wye7y8ei87ey7twuehjshdvtafsd"
//
//  }
//}
//
//
//////////////////////////////////////////////////////
//
// */