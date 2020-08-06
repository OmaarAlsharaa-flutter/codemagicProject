import 'dart:async';

import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class  UnitBloc implements Disposable{
  List<UnitModel> products;
  HelpersApi helpersApi;



  final StreamController<List<UnitModel>> _unitController =StreamController<List<UnitModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<UnitModel>> get unitStream => _unitController.stream;
  StreamSink<String> get fetchUnits => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _unitController.close();
    _categoryController.close();
  }

  String categoryId ;

  UnitBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _unitController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    this.products = await helpersApi.getUnitsData();
    _unitController.add(this.products);
  }

}