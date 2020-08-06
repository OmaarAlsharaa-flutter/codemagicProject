import 'dart:async';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class  SearchBloc implements Disposable{
  List<SearchModel> products;
  HelpersApi helpersApi;

  final StreamController<List<SearchModel>> _searchController =StreamController<List<SearchModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<SearchModel>> get searchStream => _searchController.stream;
  StreamSink<String> get fetchSearchResult => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _searchController.close();
    _categoryController.close();
  }

  String categoryId ;

  SearchBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _searchController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.get('hasSessionId');
    this.products = await helpersApi.searchList(sessionId , categoryId);
    _searchController.add(this.products);
  }

}