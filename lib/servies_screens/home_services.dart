import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/Model/service_model/serviceModel.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/servies_screens/products_in_services.dart';
import 'package:delevery_online/streams_bloc/home_service_bloc.dart';
import 'package:delevery_online/streams_bloc/item_count_in_cart_bloc.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeService extends StatefulWidget {
  final String idComing;
  final String nameComing;
  final bool isHasUnit;
  final String servicePic;
  final String sessionId;
  HomeService({this.sessionId , this.idComing , this.nameComing , this.isHasUnit, this.servicePic});

  @override
  _HomeServiceState createState() => _HomeServiceState();
}

class _HomeServiceState extends State<HomeService> {
  final helpersApi = new HelpersApi();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  String imagesUrl = ApiUtil.imagesUrl;
  bool isHasServiceUnit = false;
  String pictureOfService = '';
  HomeServiceBloc homeServiceBloc;

  // Search and cart

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
              builder: (context) => HomeService(
                sessionId: widget.sessionId,
                idComing: widget.idComing,
                servicePic: widget.servicePic,
                isHasUnit: widget.isHasUnit,
                nameComing: widget.nameComing,
              )
          ));
        })],
      ),
    );
  }
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
  Widget numOfItemWidget ;
  Widget homeService ;
  //


  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    homeServiceBloc = new HomeServiceBloc();
    itemInCartBloc = new ItemInCartBloc();
    _searchController = new TextEditingController();
    appBarTitle = new Text('${widget.nameComing}');
    numOfItemWidget = new StreamBuilder(
      stream: itemInCartBloc.cartStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<CartModel>> snapShotCart) {
        switch (snapShotCart.connectionState) {
          case ConnectionState.none:
            return Container();
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
            }else{
              return Container();
            }

            break;
        }
        return Container();
      },
    );
    homeService = new StreamBuilder(
      stream: homeServiceBloc.homeServiceStream,
      builder: (BuildContext context, AsyncSnapshot<List<ServiceModel>> snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.none:
            return error("No Thing Working");
            break;
          case ConnectionState.waiting:
            homeServiceBloc.fetchHomeService.add(widget.idComing);
            return loading();
            break;
          case ConnectionState.done:
          case ConnectionState.active:
            if(snapShot.hasError){
              return error(snapShot.error.toString());
            }else{
              if(! snapShot.hasData){
                return Container(child: Text('No Data Avilaible'),);
              }else{
                if(snapShot.data.isEmpty){
                  return _noData();
                }
                return servicesGrid(snapShot.data);
              }
            }
            break;
        }
        return Container();
      },

    );

  }

  @override
  void dispose() {
    itemInCartBloc.dispose();
    homeServiceBloc.dispose();
    _searchController.dispose();
    homeService = new Container();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(context),
        body: (searchresult.length != 0 || _searchController.text.isNotEmpty && _isSearching == true)
            ? FutureBuilder(
          future: helpersApi.searchList( widget.sessionId , _searchText),
          builder: (BuildContext context,
              AsyncSnapshot<List<SearchModel>> snapShot) {
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
            :homeService);
  }

  Widget servicesGrid(List<ServiceModel> servicesCategory) {
    return OrientationBuilder(builder: (context, orientation) {
      return CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () async {
                    if(servicesCategory[index].is_have_unites_in_final_page == true){
                      isHasServiceUnit = true;
                    }else{
                      isHasServiceUnit = widget.isHasUnit;
                    }
                    if(servicesCategory[index].pic != null){
                      pictureOfService = servicesCategory[index].pic;
                    }else{
                      pictureOfService = widget.servicePic;
                    }
                    SharedPreferences category__Id = await SharedPreferences.getInstance();
                    category__Id.setString('category__Id', servicesCategory[index].id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: true,
                        settings: RouteSettings(name: "product_service"),
                        builder: (BuildContext context) =>
                            ProductsInServices('0' , widget.idComing ,servicesCategory[index].title , isHasServiceUnit , pictureOfService , widget.sessionId , 0 , index , false),
                      ),
                    );
                    Navigator.popUntil(context,ModalRoute.withName("product_service"));
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                                ProductsInServices('0' , widget.idComing ,servicesCategory[index].title , isHasServiceUnit , pictureOfService)));
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl:
                      "$imagesUrl${servicesCategory[index].pic}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${servicesCategory[index].title}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.end,
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
                );
              }, childCount: servicesCategory.length))
        ],
      );
    });
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
            Text("لا يوجد تصنيفات  ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black45 ),),

          ],
        ),
      ),
    );
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
      this.appBarTitle = Text("${widget.nameComing}");
      _isSearching = false;
      _searchController.clear();
    });
  }


}