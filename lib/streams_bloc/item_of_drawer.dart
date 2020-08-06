import 'dart:async';

import 'package:delevery_online/Model/service_model/servixe_list_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class  ItemOfDrawerBloc implements Disposable{
  List<ServiceListModel> products;
  HelpersApi helpersApi;



  final StreamController<List<ServiceListModel>> _ItemInDrawerController =StreamController<List<ServiceListModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<ServiceListModel>> get itemInCartStream => _ItemInDrawerController.stream;
  StreamSink<String> get fetchItemInCart => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _ItemInDrawerController.close();
    _categoryController.close();
  }

  String categoryId ;

  ItemOfDrawerBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _ItemInDrawerController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    this.products = await helpersApi.fetchServiceList();
    _ItemInDrawerController.add(this.products);

  }

}