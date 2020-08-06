import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/Model/service_model/product_service_model.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/Model/service_model/serviceModel.dart';
import 'package:delevery_online/Model/service_model/sub_service_category.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/other/final_page_testing.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/servies_screens/home_product_service_bloc.dart';
import 'package:delevery_online/servies_screens/single_product_service.dart';
import 'package:delevery_online/streams_bloc/home_service_bloc.dart';
import 'package:delevery_online/streams_bloc/item_count_in_cart_bloc.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ProductsInServices extends StatefulWidget {
  final String categoryId     ;
  final String serviceIdComing;
  final String serviceName    ;
  final bool   isHasUnit      ;
  final String servicePic     ;
  final String sessionId;
  final int currIndex;
  final int subCategoryIndex ;
  final bool isFromMainPage;
//  final List<ProductServiceModel> productList;
//  final List<ServiceModel> serviceList;

  ProductsInServices(this.categoryId, this.serviceIdComing, this.serviceName,
      this.isHasUnit, this.servicePic,this.sessionId, this.currIndex , this.subCategoryIndex, this.isFromMainPage);

  @override
  _ProductsInServicesState createState() => _ProductsInServicesState();
}

class _ProductsInServicesState extends State<ProductsInServices> with TickerProviderStateMixin{
  HelpersApi helpersApi = new HelpersApi();
  HomeProductServiceBloc homeProductServiceBloc;
  String imagesUrl = ApiUtil.imagesUrl;
  double startVal;

  // Search and cart
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchController;
  bool _isSearching;
  String _searchText = "";
  int current_index = 0;
  TabController tabController;
  List searchresult = new List();
  Widget appBarTitle ;
  ItemInCartBloc itemInCartBloc;
  Widget numOfItemWidget ;
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  HomeServiceBloc homeServiceBloc;
  bool isHasSub = false;
  ScrollController _scrollController = new ScrollController();
  ValueNotifier valueNotifier;
  Future<Null> checkInternetConnection() async {
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          } else {
            showDialogNoInternet(); // show dialog
          }
        }).catchError((error) {
          showDialogNoInternet(); // show dialog
        });
      } on SocketException catch (_) {
        showDialogNoInternet();// show dialog
      }
    });
  }
  void showDialogNoInternet() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("غير متصل بالانترنت"),
        content: Text("الرجاء التأكد من الاتصال بالانترنت"),
        actions: <Widget>[FlatButton(child: Text("إعادة المحاولة"), onPressed: () {
          Navigator.of(context).pop(true);
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => ProductsInServices(
                  widget.categoryId,
                  widget.serviceIdComing,
                  widget.serviceName,
                  widget.isHasUnit,
                  widget.servicePic,
                  widget.sessionId,
                  current_index,
                widget.subCategoryIndex,
                widget.isFromMainPage
              )
          ));
        })],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    valueNotifier = ValueNotifier(widget.currIndex);
    current_index = widget.currIndex;
    itemInCartBloc = new ItemInCartBloc();
    homeServiceBloc = new HomeServiceBloc();
    _searchController = new TextEditingController();
    appBarTitle = new Text('${widget.serviceName}');
    numOfItemWidget = new StreamBuilder(
      stream: itemInCartBloc.cartStream,
      builder: (BuildContext context, AsyncSnapshot<List<CartModel>> snapShotCart) {
        switch (snapShotCart.connectionState) {
          case ConnectionState.none:
            error("none");
            break;
          case ConnectionState.waiting:
            itemInCartBloc.fetchItemInCart.add('0');
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapShotCart.hasData){
              return (snapShotCart.data.length == 0)
                  ? new Container()
                  : new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      new Icon(Icons.brightness_1,
                          size: 20.0, color: ScreenUtileColors.fontColor),
                      new Positioned(
                          top: 3.0,
                          right: 8.0,
                          child: new Center(
                            child: new Text(
                              snapShotCart.data.length.toString(),
                              style: new TextStyle(
                                  color: ScreenUtileColors.mainBlue,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  ));
            }else if (snapShotCart.hasError){
              return Container();
            }

            break;
        }
        return Container();
      },
    );
    homeProductServiceBloc = new HomeProductServiceBloc();
  }

  @override
  void dispose() {
    itemInCartBloc.dispose();
    homeServiceBloc.dispose();
    _searchController.dispose();
    homeProductServiceBloc.dispose();
    super.dispose();
  }

  callApi(){

  }
  @override
  Widget build(BuildContext context ) {
    screenConfig = new ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
    List<Map<String, dynamic>> productsOnCart = [] ;
    List<Map<String, dynamic>> myProduct = [];
    Widget _drawSingleProduct(SubServiceCategory subService , List<ProductServiceModel> listProducts , int position){
        if(subService.id == listProducts[position].category_id){
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> SingleProductServies(
                listProducts[position],
//                sessionId: widget.sessionId,
//                categoryId: widget.categoryId,
//                isHasUnit: widget.isHasUnit,
//                serviceIdComing: widget.serviceIdComing,
//                serviceName: widget.serviceName,
//                servicePic: widget.servicePic,
//                currIndex: valueNotifier.value,
              )));
            },
            child: Card(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width:
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    Container(
                      width: (screenConfig.screenType == ScreenType.SMALL)?75:80,
                      height:(screenConfig.screenType == ScreenType.SMALL)?75:80,
                      child: CachedNetworkImage(
                        imageUrl: "$imagesUrl${listProducts[position].pic}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Image(
                          image: AssetImage("assests/images/giphy.gif"),
                          width: 12,
                          height: 12,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    Container(
                      width: 80,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            listProducts[position].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            textWidthBasis:
                            TextWidthBasis.parent,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          (listProducts[position]
                              .price_visible)
                              ? Text(listProducts[position].price)
                              : Text(""),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      //color: Colors.red,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Center(child: Text("الكمية")),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: <Widget>[
                              new IconButton(
                                  icon:
                                  Icon(Icons.add_circle),
                                  onPressed: () {
                                    if (listProducts[position].quantity_type ==
                                        'BOX') {
                                      startVal = 1.0;
                                    } else {
                                      startVal = 0.5;
                                    }
                                    _addProduct(listProducts,
                                        position, startVal);
                                  }),
                              ValueListenableBuilder(
                                valueListenable: listProducts[position].valueNotifier,
                                builder: (context, value, child) {
                                  return Text(value);
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons
                                      .do_not_disturb_on),
                                  onPressed: () async{
                                    if (listProducts[position].quantity_type ==
                                        'BOX') {
                                      startVal = 1.0;
                                    } else {
                                      startVal = 0.5;
                                    }
                                    _subProduct(listProducts,
                                        position, startVal);
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width:
                      MediaQuery.of(context).size.width *
                          0.02,
                    ),
                  ],
                ),
              ),
            ),
          );
        }else{
          return Container();
        }

    }
    Widget _drawProducts(List<ProductServiceModel> listProducts){
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: listProducts.length,
                itemBuilder: (context, position) {
                  print(listProducts[position].valueNotifier.value);
                  productsOnCart.add({
                    "product_name": listProducts[position].title,
                    "price": listProducts[position].price,
                    "quantity": listProducts[position].valueNotifier,
                  });
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> SingleProductServies(
                        listProducts[position],
                      )));
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width *
                                  0.02,
                            ),
                            Container(
                              width: (screenConfig.screenType == ScreenType.SMALL)?75:80,
                              height:(screenConfig.screenType == ScreenType.SMALL)?75:80,
                              child: CachedNetworkImage(
                                imageUrl: "$imagesUrl${listProducts[position].pic}",
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Image(
                                  image: AssetImage("assests/images/giphy.gif"),
                                  width: 12,
                                  height: 12,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            SizedBox(
                              width: 25.0,
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    listProducts[position].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    textWidthBasis:
                                    TextWidthBasis.parent,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  (listProducts[position]
                                      .price_visible)
                                      ? Text(listProducts[position].price)
                                      : Text(""),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                              //color: Colors.red,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(child: Text("الكمية")),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new IconButton(
                                          icon:
                                          Icon(Icons.add_circle),
                                          onPressed: () {
                                            if (listProducts[position].quantity_type ==
                                                'BOX') {
                                              startVal = 1.0;
                                            } else {
                                              startVal = 0.5;
                                            }
                                            //                                       productsOnCart = [];
//
//                                        listProducts[position].addListener(_addProduct(listProducts,
//                                            position, startVal , productsOnCart));
                                            _addProduct(listProducts,
                                                position, startVal);
                                          }),
                                      ValueListenableBuilder(
                                        valueListenable: listProducts[position].valueNotifier,
                                        builder: (context, value, child) {
                                          return Text(value);
                                        },
                                      ),
//                                  new Text(
//                                      '${listProducts[position].startServiceQuantityValue.toString()}'),
                                      IconButton(
                                          icon: Icon(Icons
                                              .do_not_disturb_on),
                                          onPressed: () {
                                            if (listProducts[position].quantity_type ==
                                                'BOX') {
                                              startVal = 1.0;
                                            } else {
                                              startVal = 0.5;
                                            }
                                            //  productsOnCart = [];
                                            _subProduct(listProducts,
                                                position, startVal);
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width *
                                  0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.only(right: 10 , left: 10),
//              bottom: 0,
//              right: 10,
//              left: 10,
            child: RaisedButton(
              color: ScreenUtileColors.mainBlue,
              child: Center(
                child: Text(
                  "التالي",
                  style: TextStyle(
                      color: ScreenUtileColors.fontColor),
                ),
              ),
              onPressed: () async {
                for (int i = 0; i < productsOnCart.length; i++) {
                  if (productsOnCart[i]['quantity'].toString().contains("0.0")) {
                    print("non");
                  }else{
                    print("ddddddddd ${productsOnCart[i]['quantity'].toString().length}");
                    myProduct.add({
                      "product_name": productsOnCart[i]['product_name'],
                      "price": productsOnCart[i]['price'],
                      "quantity": productsOnCart[i]['quantity'].toString().replaceRange(0, productsOnCart[i]['quantity'].toString().length -5, ''),

                      "break": "break",
                    });
                  }
                }
                if(myProduct.length != 0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      maintainState: true,
                      settings: RouteSettings(name: "finalPageTesting"),
                      builder: (context) =>
                          FinalPageScreen(
                            serviceIdComing: widget.serviceIdComing,
                            serviceNameComing:  widget.serviceName ,
                            isHasUnitInFinalPage: widget.isHasUnit,
                            productsQuantity: myProduct,
                            serviceCover: widget.servicePic,
                          ),
                    ),
                  );
                  Navigator.popUntil(context,ModalRoute.withName("finalPageTesting"));
                }else {
                  Fluttertoast.showToast(
                      msg:
                      "الرجاء إختيار الكميات التي تريد طلبها");
                }

              },
            ),
          ),
        ],
      );
    }
    Widget _drawProducts2(SubServiceCategory subService , List<ProductServiceModel> listProducts){
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: listProducts.length,
                itemBuilder: (context, position) {
                  productsOnCart.add({
                    "product_name": listProducts[position].title,
                    "price": listProducts[position].price,
                    "quantity": listProducts[position].valueNotifier,
                  });
                  return _drawSingleProduct(subService, listProducts, position);
                }),
          ),
          Container(
            padding: EdgeInsets.only(right: 10 , left: 10),
//              bottom: 0,
//              right: 10,
//              left: 10,
            child: RaisedButton(
              color: ScreenUtileColors.mainBlue,
              child: Center(
                child: Text(
                  "التالي",
                  style: TextStyle(
                      color: ScreenUtileColors.fontColor),
                ),
              ),
              onPressed: () async {
                for (int i = 0; i < productsOnCart.length; i++) {
                  if (productsOnCart[i]['quantity'].toString().contains("0.0")) {
                    debugPrint("non");
                  }else{
                    myProduct.add({
                      "product_name": productsOnCart[i]['product_name'],
                      "price": productsOnCart[i]['price'],
                      "quantity": productsOnCart[i]['quantity'].toString().replaceRange(0, productsOnCart[i]['quantity'].toString().length -5, ''),
                      "break": "break",
                    });
                  }
                }
                if(myProduct.length != 0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      maintainState: true,
                      settings: RouteSettings(name: "finalPageTesting"),
                      builder: (context) =>
                          FinalPageScreen(
                            serviceIdComing: widget.serviceIdComing,
                            serviceNameComing:  widget.serviceName ,
                            isHasUnitInFinalPage: widget.isHasUnit,
                            productsQuantity: myProduct,
                            serviceCover: widget.servicePic,
                          ),
                    ),
                  );
                  Navigator.popUntil(context,ModalRoute.withName("finalPageTesting"));
                }else {
                  Fluttertoast.showToast(
                      msg:
                      "الرجاء إختيار الكميات التي تريد طلبها");
                }

              },
            ),
          ),
        ],
      );
    }
    Widget _screen(List<SubServiceCategory> subCategory , List<ProductServiceModel> productList) {
      tabController = TabController(initialIndex: valueNotifier.value, length: subCategory.length, vsync: this);
      return Scaffold(
        appBar: AppBar(
            centerTitle: false, title: appBarTitle,
            bottom: TabBar(
                onTap: (int index){
                  this.valueNotifier.value = index;
                  setState(() {
                  });
                },
                indicatorColor: Colors.white,
                labelColor: Colors.white70,
                controller: tabController,
                isScrollable: true,
                tabs: _tabs(subCategory)),
            actions: <Widget>[
              IconButton(
                icon: icon,
                onPressed: () {
                  setState(() {
                    if (this.icon.icon == Icons.search) {
                      this.icon = new Icon(
                        Icons.close,
                        color: Colors.white,
                      );
                      this.appBarTitle = new TextField(
                        controller: _searchController,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                            prefixIcon: new Icon(Icons.search, color: Colors.white),
                            hintText: "البحث ...",
                            hintStyle: new TextStyle(color: Colors.white)),
                        onChanged: _SearchListExampleState(),
                      );
                      _handleSearchStart();
                    } else {
                      _handleSearchEnd();
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Container(
                    height: 200.0,
                    width: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => CartScreenTest(widget.sessionId)));
                      },
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: IconButton(
                              icon: new Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CartScreenTest(widget.sessionId)));
                              },
                            ),
                          ),
                          numOfItemWidget,
                        ],
                      ),
                    )),
              ),
            ]
        ),
        body: (searchresult.length != 0 || _searchController.text.isNotEmpty && _isSearching == true)
            ? FutureBuilder(
          future: helpersApi.searchList( widget.sessionId , _searchText),
          builder: (BuildContext context, AsyncSnapshot<List<SearchModel>> snapShot) {
            switch (snapShot.connectionState) {
              case ConnectionState.none:
                error("No Data Returned");
                break;
              case ConnectionState.waiting:
                return loading();
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapShot.hasData){
                  return searchResult(snapShot.data , context , imagesUrl);
                }else{
                  return noSearchData(context);
                }
                break;
            }
            return Container();
          },
        )
            :_drawProducts2(subCategory[valueNotifier.value],productList)
      );
    }
    Widget _screenWithOutSub(BuildContext context) {
      return Scaffold(
        appBar: buildAppBar(context),
        body: (searchresult.length != 0 || _searchController.text.isNotEmpty && _isSearching == true)
            ? FutureBuilder(
          future: helpersApi.searchList( widget.sessionId , _searchText),
          builder: (BuildContext context, AsyncSnapshot<List<SearchModel>> snapShot) {
            switch (snapShot.connectionState) {
              case ConnectionState.none:
                error("No Data Returned");
                break;
              case ConnectionState.waiting:
                return loading();
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapShot.hasData){
                  return searchResult(snapShot.data , context , imagesUrl);
                }else{
                  return noSearchData(context);
                }
                break;
            }
            return Container();
          },
        )
            :Container(
          child: StreamBuilder(
            stream: homeProductServiceBloc.productsStream,
            builder: (BuildContext context , AsyncSnapshot<List<ProductServiceModel>> snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return error("No Thing Working");
                  break;
                case ConnectionState.waiting:
                  homeProductServiceBloc.fetchProduct.add(widget.serviceIdComing);
                  return loading();
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if(snapshot.hasError){
                    return error(snapshot.error.toString());
                  }else{
                    if(! snapshot.hasData){
                      return Container(child: Text('No Data Avilaible'),);
                    }else{
                      if(snapshot.data.isEmpty){
                        return _noData();
                      }
                      return _drawProducts(snapshot.data);
                    }
                  }
                  break;
              }
              return Container();

            },
          ),
        ),
      );
    }
    if(widget.isFromMainPage == false){
      return StreamBuilder(
        stream: homeServiceBloc.homeServiceStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ServiceModel>> snapShotCategory) {
          switch (snapShotCategory.connectionState) {
            case ConnectionState.none:
              error("no Thing");
              break;
            case ConnectionState.waiting:
              homeServiceBloc.fetchHomeService.add(widget.serviceIdComing);
              return loading();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapShotCategory.data[widget.subCategoryIndex].sub_categories.length > 0) {
                isHasSub = true;
                // homeProductServiceBloc.fetchProduct.add(snapShotCategory.data[0].sub_categories[current_index].id);
                return _screen(snapShotCategory.data[widget.subCategoryIndex].sub_categories , snapShotCategory.data[0].products);
              }
              else
                return _screenWithOutSub(context);
              break;
          }
          return Container(child: Center(child: Text("No Data"),),);
        },
      );
    }else{
      return _screenWithOutSub(context);
    }
  }


  List<Tab> _tabs(List<SubServiceCategory> subCategories) {
    List<Tab> tabs = [];
    for (SubServiceCategory subCategory in subCategories) {
      tabs.add(Tab(
        text: subCategory.title,
      ));
    }
    return tabs;
  }
  _addProduct(List<ProductServiceModel> products, int index, double incValue) async{
    products[index].startServiceQuantityValue += incValue;
    products[index].valueNotifier.value = "${products[index].startServiceQuantityValue}";
  }
  _subProduct(List<ProductServiceModel> products, int index, double decValue) {
  //  productsOnCart = [];
    if (products[index].startServiceQuantityValue > 0)
      products[index].startServiceQuantityValue -= decValue;
    products[index].valueNotifier.value = "${products[index].startServiceQuantityValue}";

  }
  Widget _noData (){
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image(image: AssetImage("assests/images/lost-items.png"),height: 200,width:300 ,),
            SizedBox(height: 8,),
            Text("لا يوجد منتجات هنا :(  ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black45 ),),

          ],
        ),
      ),
    );
  }
  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: false, title: appBarTitle, actions: <Widget>[
      IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchController,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "البحث ...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: _SearchListExampleState(),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
            height: 200.0,
            width: 50.0,
            child: new GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => CartScreenTest(widget.sessionId)));
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: IconButton(
                      icon: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CartScreenTest(widget.sessionId)));
                      },
                    ),
                  ),
                  numOfItemWidget,
                ],
              ),
            )),
      ),
    ]);
  }
  _SearchListExampleState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchController.text;
        });
      }
    });
  }
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text("${widget.serviceName}");
      _isSearching = false;
      _searchController.clear();
    });
  }

}
