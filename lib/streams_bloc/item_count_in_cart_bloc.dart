import 'dart:async';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/interfaces/contracts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class  ItemInCartBloc implements Disposable{
  List<CartModel> products;
  HelpersApi helpersApi;



  final StreamController<List<CartModel>> _itemInCartController =StreamController<List<CartModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<CartModel>> get cartStream => _itemInCartController.stream;
  StreamSink<String> get fetchItemInCart => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _itemInCartController.close();
    _categoryController.close();
  }

  String categoryId ;

  ItemInCartBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _itemInCartController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.get('hasSessionId');
    this.products = await helpersApi.fetchProductInCart(sessionId);
    _itemInCartController.add(this.products);
  }

}