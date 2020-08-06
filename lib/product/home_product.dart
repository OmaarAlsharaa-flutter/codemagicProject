import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/product/home_product_bloc.dart';
import 'package:delevery_online/product/single_product.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/streams_bloc/item_count_in_cart_bloc.dart';
import 'package:delevery_online/streams_bloc/sub_category_bloc.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import '../Model/category.dart';
import '../Model/product.dart';
import '../Model/subCategory.dart';
import '../api/apiUtil.dart';
import '../api/helpersApi.dart';

class HomeProduct extends StatefulWidget {
  @override
  _HomeProductState createState() => _HomeProductState();
  final String idComing;
  final String nameCategory;
  final bool isHasSubCategory;
  final String sessionId;
  final int currIndex ;

  HomeProduct({this.sessionId ,this.idComing , this.nameCategory , this.isHasSubCategory, this.currIndex});
}

class _HomeProductState extends State<HomeProduct>
    with TickerProviderStateMixin{

  // Search and cart

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchController;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();
  Widget appBarTitle ;
  ItemInCartBloc itemInCartBloc;
  SubCategoryBloc subCategoryBloc;
  Widget numOfItemWidget ;
  ScrollController _scrollController = new ScrollController();
  //
  final helpersApi = new HelpersApi();
  TabController tabController;
  List<SubCategory> subCategories;
  List<Product> productCategory;
  int current_index = 0;
  Category category;
  String categoryId;
  bool hasSubCategory = false;
  bool price_visible = true;
  HomeProductBloc homeProductBloc;
  String imagesUrl = ApiUtil.imagesUrl;
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  Widget _drawStreamProduct;
  Widget _drawBasePage;
//  String idTesting;

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
        actions: <Widget>[
          FlatButton(
              child: Text("إعادة المحاولة"),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => HomeProduct(
                          sessionId: widget.sessionId,
                          idComing: widget.idComing,
                          nameCategory:  widget.nameCategory,
                          isHasSubCategory: widget.isHasSubCategory,
                            currIndex : widget.currIndex
                        )));
              })
        ],
      ),
    );
  }
  //////////////////////


  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    current_index = widget.currIndex;
    homeProductBloc = new HomeProductBloc();
    subCategoryBloc = new SubCategoryBloc();
    _searchController = new TextEditingController();
    itemInCartBloc = new ItemInCartBloc();
    _searchController = new TextEditingController();
    appBarTitle = new Text("${widget.nameCategory}");
    _drawBasePage = new StreamBuilder(
      stream: subCategoryBloc.categoryStream,
      builder: (BuildContext context,
          AsyncSnapshot<Category> snapShotCategory) {
        switch (snapShotCategory.connectionState) {
          case ConnectionState.none:
            error("no thing");
            break;
          case ConnectionState.waiting:
            subCategoryBloc.fetchCategories.add(widget.idComing);
            return loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapShotCategory.data.has_sub_categories == true) {
              homeProductBloc.fetchProduct.add(snapShotCategory.data.sub_categories[current_index].id);
              return _screen(snapShotCategory.data.sub_categories);
            }
            else
              return _screenWithOutSub(context);
            break;
        }
        return Container();
      },
    );
    _drawStreamProduct = new StreamBuilder(
      stream: homeProductBloc.productsStream,
      builder: (BuildContext context , AsyncSnapshot<List<Product>> snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            return error("No Thing Working");
            break;
          case ConnectionState.waiting:
            return loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError){
              return error(snapshot.error.toString());
            }else{
              if(!snapshot.hasData){
                return _noData();
              }else{
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                });
                return _drawProducts(snapshot.data);

              }
            }
            break;
        }
        return Container();

      },
    );
    numOfItemWidget = new StreamBuilder(
      stream: itemInCartBloc.cartStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<CartModel>> snapShotCart) {
        switch (snapShotCart.connectionState) {
          case ConnectionState.none:
            error("none");
            break;
          case ConnectionState.waiting:
            itemInCartBloc.fetchItemInCart.add('0');
            break;
          case ConnectionState.active:
          case ConnectionState.done:
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
            break;
        }
        return Container();
      },
    );

  }
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    widget.testId = null;
//  }

  @override
  void dispose() {
    if(hasSubCategory == true) tabController.dispose();
    itemInCartBloc.dispose();
    _scrollController.dispose();
    subCategoryBloc.dispose();
    _searchController.dispose();
    homeProductBloc.dispose();
    _drawStreamProduct = new Container();
    _drawBasePage = new Container();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    screenConfig = new ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
      return _drawBasePage;

//    else{
//      return _screenWithOutSub(context);
//    }
  }

  Widget _screen(List<SubCategory> subCategory) {

    tabController = TabController(initialIndex: widget.currIndex, length: subCategory.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
            Navigator.of(context).pop(true);
            Navigator.pushReplacementNamed(context, '/homePage');
              }
          ),
        centerTitle: false, title: appBarTitle,
        bottom: TabBar(
          onTap: (int index){
            current_index = index;
          //  idTesting = subCategory[index].id;
            homeProductBloc.fetchProduct.add(subCategory[index].id);
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
                      onChanged: _searchListExampleState(),
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
          :Container(child: _drawStreamProduct,
      ),
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
          stream: homeProductBloc.productsStream,
          builder: (BuildContext context , AsyncSnapshot<List<Product>> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return error("No Thing Working");
                break;
              case ConnectionState.waiting:
                homeProductBloc.fetchProduct.add(widget.idComing);
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
  List<Tab> _tabs(List<SubCategory> subCategories) {
    List<Tab> tabs = [];
    for (SubCategory subCategory in subCategories) {
      tabs.add(Tab(
        text: subCategory.title,
      ));
    }
    return tabs;
  }
  Widget _drawProducts(List<Product> products){
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                itemCount: products.length ,
                controller: _scrollController,
                itemBuilder: (context , position){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            maintainState: true,
                          settings: RouteSettings(name: 'singleProduct'),
                          builder: (BuildContext context)  => SingleProduct(products[position] , true , widget.sessionId , widget.nameCategory , widget.isHasSubCategory ,widget.idComing, indexComeFrom: current_index,)
                          )
                      );
                      Navigator.popUntil(context, ModalRoute.withName('singleProduct'));

                    },
                    child: Card (
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                  //         CircleAvatar( radius: 50, backgroundImage: CachedNetworkImageProvider('$imagesUrl${products[position].pic}',),backgroundColor: Colors.transparent,),
                           Container(
                             width: 90,
                             height:90,
                              child: CachedNetworkImage(
                                imageUrl: "$imagesUrl${products[position].pic}",
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
                            SizedBox(width: 40.0,),
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0,),
                                  Text('${products[position].title}',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),),
                                  SizedBox(height: 20.0,),
                                  (products[position].price_visible)?(Text('${products[position].price} ل.س ')):(Text('')),
                                  SizedBox(height: 20.0,),
                                ],
                              ),
                            ),
                            SizedBox (width: MediaQuery.of(context).size.width * 0.03,),
                          ],
                        ),
                      ),
                    ),
                  );

                }),
          )
        ],
      ),
    );
  }
  _searchListExampleState() {
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
                onChanged: _searchListExampleState(),
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
    ],leading: IconButton(icon:Icon(Icons.arrow_back),
        onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
    ));
  }
  Widget buildAppBarWithTab(BuildContext context) {
    return new AppBar(centerTitle: false, title: appBarTitle,
        bottom: TabBar(
            onTap: (int index){
              homeProductBloc.fetchProduct.add(this.subCategories[index].id);
            },
            indicatorColor: Colors.white,
            labelColor: Colors.white70,
            controller: tabController,
            isScrollable: true,
            tabs: _tabs(subCategories))
        , actions: <Widget>[
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
                onChanged: _searchListExampleState(),
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
    ],leading: IconButton(icon:Icon(Icons.arrow_back),
        onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
    ));
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
      this.appBarTitle = Text("${widget.nameCategory}");
      _isSearching = false;
      _searchController.clear();
    });
  }


}
