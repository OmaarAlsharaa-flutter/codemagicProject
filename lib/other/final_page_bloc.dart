import 'dart:async';

import 'package:delevery_online/Model/service_model/final_page_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class  FinalPageBloc implements Disposable{
  List<FinalPageModel> products;
  HelpersApi helpersApi;



  final StreamController<List<FinalPageModel>> _finalPageController =StreamController<List<FinalPageModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<FinalPageModel>> get finalPageStream => _finalPageController.stream;
  StreamSink<String> get fetchFinalPage => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _finalPageController.close();
    _categoryController.close();
  }

  String categoryId ;

  FinalPageBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _finalPageController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{
    this.products = await helpersApi.printFinalPage(categoryId);
    _finalPageController.add(this.products);
  }

}