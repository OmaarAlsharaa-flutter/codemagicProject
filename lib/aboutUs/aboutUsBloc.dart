import 'dart:async';

import 'package:delevery_online/Model/about_us_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';



class  AboutUsBloc implements Disposable{
  AboutUsModel aboutUsModel;
  HelpersApi helpersApi;

  final StreamController<AboutUsModel> _aboutUsController =StreamController<AboutUsModel>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<AboutUsModel> get aboutUsStream => _aboutUsController.stream;
  StreamSink<String> get fetchAboutUs => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _aboutUsController.close();
    _categoryController.close();
  }

  String categoryId ;

  AboutUsBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    aboutUsModel= new AboutUsModel();
    _aboutUsController.add(aboutUsModel);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    this.aboutUsModel = await helpersApi.fetchAboutUs();
    _aboutUsController.add(this.aboutUsModel);


  }

}