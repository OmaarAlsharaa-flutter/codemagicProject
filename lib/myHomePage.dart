import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/Model/service_model/servixe_list_model.dart';
import 'package:delevery_online/Model/session.dart';
import 'package:delevery_online/Model/slider.dart';
import 'package:delevery_online/aboutUs/about_us_screen.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/contactsScreen/contactUsBloc.dart';
import 'package:delevery_online/contactsScreen/contactUsScreen.dart';
import 'package:delevery_online/foaaterScreen/onPagingFoaterScreen.dart';
import 'package:delevery_online/other/final_page_testing.dart';
import 'package:delevery_online/pharmacyScreen/onPagingPhamacyScreen.dart';
import 'package:delevery_online/product/home_product.dart';
import 'package:delevery_online/product/single_product.dart';
import 'package:delevery_online/public_methods.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/servies_screens/home_services.dart';
import 'package:delevery_online/servies_screens/products_in_services.dart';
import 'package:delevery_online/streams_bloc/category_bloc.dart';
import 'package:delevery_online/streams_bloc/item_count_in_cart_bloc.dart';
import 'package:delevery_online/streams_bloc/item_of_drawer.dart';
import 'package:delevery_online/streams_bloc/search_model_bloc.dart';
import 'package:delevery_online/streams_bloc/slider_bloc.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //For Search Method

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchController;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();
  String sliderTitle = '';
  String PLAY_STORE_URL ='https://play.google.com/store/apps/details?id=com.syweb.deleveryonline';

  versionCheck(context) async {
    //Get Current installed version of app
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String serverAppVersion = sharedPreferences.getString('version_number');
    final PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version.trim();
    try {
      // Using default duration to force fetching from remote server.
      if (serverAppVersion != currentVersion) {
        _showVersionDialog(context);
      }
    } on Exception catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    //Get Latest version info from firebase config
    print("cuuu $currentVersion");
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = 'يتوفر تحديث جديد';
        String message = 'يتوفر إصدار أحدث من التطبيق ، يرجى تحديثه الآن.';
        String btnLabel = 'التحديث الآن';
        return  WillPopScope(
          child: new AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              RaisedButton(
                color:ScreenUtileColors.mainBlue,
                child: Text(btnLabel , style: TextStyle(color:ScreenUtileColors.fontColor ),),
                onPressed: () => _launchURL(PLAY_STORE_URL),
              ),
              RaisedButton(
                color:ScreenUtileColors.mainBlue,
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('خروج'),
              ),
            ],
          ), onWillPop: () {},
        );
      },
    );
  }

  //
  PublicMethods publicMethods = new PublicMethods();
  SliderBloc sliderBloc;
  CategoryBloc categoryBloc;
  ItemOfDrawerBloc itemOfDrawerBloc;
  ItemInCartBloc itemInCartBloc;
  ContactUsBloc contactUsBloc;
  SearchBloc searchBloc;
  Session session;
  String sessionIding;
  String imagesUrl = ApiUtil.imagesUrl;
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  Product productNew;
  MainSetting mainSetting;
  List<Product> productsNew;
  HelpersApi helpersApi = new HelpersApi();
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  String sessionId;
  Widget numOfItemWidget;
  Widget phone;
  Widget appBarTitle;
  Widget sliderWidget;
  Widget categoryWidget;
  Widget categoryWidgetHorizantal;
  int numOfRaw = 3;
  int numOfRawHorizential = 5;
  bool isConnected = true;
  String phoneNumber = "";

  Future<String> _hasSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('hasSessionId') == null) {
      await helpersApi.fetchSessionId();
    } else {
      setState(() {
        sessionId = prefs.getString('hasSessionId');
      });
    }
    return sessionId;
  }

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
        showDialogNoInternet(); // show dialog
      }
    });
  }
  void getMainSettings() async {
    SharedPreferences mainSettingsPref = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = mainSettingsPref.get('phone');
    });
    if (mainSettingsPref.get('phone') == "") {
      appBarTitle = new Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "ديليفري أون لاين",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      appBarTitle = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "ديليفري أون لاين",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '${mainSettingsPref.get('phone')}',
            style: TextStyle(fontSize: 14),
          )
        ],
      );
    }
  }

  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
    _hasSessionId();
    getMainSettings();
    checkInternetConnection();
    sliderBloc = new SliderBloc();
    categoryBloc = new CategoryBloc();
    itemOfDrawerBloc = new ItemOfDrawerBloc();
    itemInCartBloc = new ItemInCartBloc();
    contactUsBloc = new ContactUsBloc();
    searchBloc = new SearchBloc();
    _searchController = new TextEditingController();
    _isSearching = false;
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
    sliderWidget = new StreamBuilder(
      stream: sliderBloc.sliderStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SliderInfo>> snapShotSlider) {
        switch (snapShotSlider.connectionState) {
          case ConnectionState.none:
            error("None");
            break;
          case ConnectionState.waiting:
            sliderBloc.fetchSliderData.add('0');
            return loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return _headerCoursel(snapShotSlider.data);
            break;
        }
        return Container();
      },
    );
    categoryWidget = new StreamBuilder(
      stream: categoryBloc.categoryStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<Category>> snapShotCategory) {
        switch (snapShotCategory.connectionState) {
          case ConnectionState.none:
            error("خطأ بالاتصال");
            break;
          case ConnectionState.waiting:
            //  snapShotCategory.data.add(invoiceCategory);
            //  snapShotCategory.data.add(pharmacyCategory);
            categoryBloc.fetchCategories.add('0');

            return loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return _categoryGrid(context, snapShotCategory.data, numOfRaw);
            break;
        }
        return Container();
      },
    );
    categoryWidgetHorizantal = new StreamBuilder(
      stream: categoryBloc.categoryStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<Category>> snapShotCategory) {
        switch (snapShotCategory.connectionState) {
          case ConnectionState.none:
            error("خطأ بالاتصال");
            break;
          case ConnectionState.waiting:
            //      snapShotCategory.data.add(invoiceCategory);
            //      snapShotCategory.data.add(pharmacyCategory);
            categoryBloc.fetchCategories.add('0');
            return loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return _categoryGrid(
                context, snapShotCategory.data, numOfRawHorizential);
            break;
        }
        return Container();
      },
    );
  }

  Future<bool> checkIdInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
    return isConnected;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    sliderBloc.dispose();
    categoryBloc.dispose();
    itemOfDrawerBloc.dispose();
    itemInCartBloc.dispose();
    contactUsBloc.dispose();
    searchBloc.dispose();
    _searchController.dispose();
    appBarTitle = new Container();
    sliderWidget = new Container();
    categoryWidget = new Container();
    categoryWidgetHorizantal = new Container();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = new ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
    var drawerList = <Widget>[];
    Widget drawerListItem(BuildContext context, List<ServiceListModel> list) {
      for (int i = 0; i < list.length; i++) {
        drawerList.add(Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.settings),
                title: new Text(list[i].title),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String sessionId = prefs.get('hasSessionId');
                  String idSelected = list[i].id;
                  String serviceName = list[i].title;
                  switch (list[i].type) {
                    case 'service_categories':
                      Navigator.of(context).pop(true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: true,
                          settings: RouteSettings(name: "service_categories"),
                          builder: (context) => HomeService(
                            sessionId: sessionId,
                            idComing: list[i].id,
                            nameComing: serviceName,
                            isHasUnit: list[i].is_have_unites_in_final_page,
                            servicePic: list[i].pic,
                          ),
                        ),
                      );
                      Navigator.popUntil(
                          context, ModalRoute.withName("service_categories"));
                      break;
                    case 'service_products':
                      SharedPreferences category__Id =
                          await SharedPreferences.getInstance();
                      category__Id.setString('category__Id', '0');
                      Navigator.of(context).pop(true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: true,
                          settings: RouteSettings(name: "service_products"),
                          builder: (context) => ProductsInServices(
                              '0',
                              idSelected,
                              serviceName,
                              list[i].is_have_unites_in_final_page,
                              list[i].pic,
                              sessionId,
                            0,
                            0,
                            true
                          ),
                        ),
                      );
                      Navigator.popUntil(
                          context, ModalRoute.withName("service_products"));

                      break;
                    case 'final_page':
                      Navigator.of(context).pop(true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: true,
                          settings: RouteSettings(name: "final_page"),
                          builder: (context) => FinalPageScreen(
                            serviceIdComing: idSelected,
                            serviceNameComing: serviceName,
                            isHasUnitInFinalPage:
                                list[i].is_have_unites_in_final_page,
                            serviceCover: list[i].pic,
                          ),
                        ),
                      );
                      Navigator.popUntil(
                          context, ModalRoute.withName("final_page"));
                      break;
                    default:
                      return null;
                      break;
                  }
                },
              ),
              Divider(
                height: 5,
                color: Colors.black,
              )
            ],
          ),
        ));
      }
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: drawerList,
          ),
        ),
      );
    }

    Widget _drawerWithApi() {
      return new Drawer(
        child: StreamBuilder(
          stream: itemOfDrawerBloc.itemInCartStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ServiceListModel>> snapShotServiceList) {
            switch (snapShotServiceList.connectionState) {
              case ConnectionState.none:
                error("لا يوجد خدمات");
                break;
              case ConnectionState.waiting:
                checkInternetConnection();
                drawerList = [];
                drawerList.add(Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new ListTile(
                        leading: Icon(Icons.home),
                        title: new Text('الصفحة الرئيسية'),
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    new ListTile(
                      leading: Icon(Icons.healing),
                      title: new Text('الصيدلية الالكترونية'),
                      onTap: () async {
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "OnPagingPharmacy"),
                            builder: (context) => OnPagingPharmacy(),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("OnPagingPharmacy"));
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: new Text('دفع فواتير'),
                      onTap: () {
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "OnPagingFoater"),
                            builder: (BuildContext context) => OnPagingFoater(),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("OnPagingFoater"));
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: new Text('تواصل معنا'),
                      onTap: () async {
                        SharedPreferences mainSettingsPref = await SharedPreferences.getInstance();

                          String site_name      = mainSettingsPref.get('site_name');
                          String site_url       = mainSettingsPref.get('site_url');
                          String site_mail      = mainSettingsPref.get('site_mail');
                          String facebook_link  = mainSettingsPref.get('facebook_link');
                          String twitter_link   = mainSettingsPref.get('twitter_link');
                          String instagram_link = mainSettingsPref.get('instagram_link');
                          String phone          = mainSettingsPref.get('phone');
                          String mobile         = mainSettingsPref.get('mobile');
                          String address        = mainSettingsPref.get('address');

                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "ContactUs"),
                            builder: (BuildContext context) {
                             return ContactUs(
                                  site_name,
                                  site_url,
                                  site_mail,
                                  facebook_link,
                                  twitter_link,
                                  instagram_link,
                                  phone,
                                  mobile,
                                  address
                              );
                            },
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("ContactUs"));
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                      ),
                      title: new Text('من نحن'),
                      onTap: () {
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "AboutUs"),
                            builder: (BuildContext context) => AboutUs(),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("AboutUs"));
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                      title: new Text('صفحتنا على الفيسبوك'),
                      onTap: () async {
                        Navigator.of(context).pop(true);
                        SharedPreferences mainSettingsPref =
                            await SharedPreferences.getInstance();
                        String faceUrl = mainSettingsPref.get('facebook_link');
                        await _launchURL("$faceUrl");
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.greenAccent,
                      ),
                      title: new Text('التواصل عبر الواتس آب'),
                      onTap: () async {
                        SharedPreferences mainSettingsPref =
                            await SharedPreferences.getInstance();
                        String whatsPhone = mainSettingsPref.get('mobile');
                        String urlIfExist = "whatsapp://send?phone=$whatsPhone";
                        String urlIfNotExist =
                            "https://api.whatsapp.com/send?phone=$whatsPhone";
                        Navigator.of(context).pop(true);
                        if (await canLaunch(urlIfExist)) {
                          await launch(urlIfExist);
                        } else {
                          if (await canLaunch(urlIfNotExist)) {
                            await launch(urlIfNotExist);
                          } else {
                            throw ' Coudnt open $urlIfNotExist';
                          }
                        }
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.red.shade200,
                      ),
                      title: new Text('حسابنا على الانستغرام'),
                      onTap: () async {
                        SharedPreferences mainSettingsPref =
                        await SharedPreferences.getInstance();
                        String instagram_link = mainSettingsPref.get('instagram_link');
                        await _launchURL("$instagram_link");
                      },
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5.0,
                    ),
                  ],
                ));
                itemOfDrawerBloc.fetchItemInCart.add('0');
                return loading();
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                return drawerListItem(context, snapShotServiceList.data);
                break;
            }
            return Container();
          },
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onPressedBack,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          key: globalKey,
          appBar: buildAppBar(context),
          drawer: _drawerWithApi(),
          body: (searchresult.length != 0 ||
                  _searchController.text.isNotEmpty && _isSearching == true)
              ? FutureBuilder(
                  future: helpersApi.searchList(sessionId, _searchText),
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
                        if (!snapShot.hasData) {
                          return noSearchData(context);
                        } else {
                          return searchResult(
                              snapShot.data, context, imagesUrl);
                        }
                        break;
                    }
                    return Container();
                  },
                )
              : OrientationBuilder(
                  builder: (context, or) {
                    if (or == Orientation.portrait) {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height:MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                child: sliderWidget),
                            Container(
                              child: categoryWidget,
                            )
                          ],
                        ),
                        scrollDirection: Axis.vertical,
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                child: sliderWidget),
                            Container(
                              child: categoryWidgetHorizantal,
                            )
                          ],
                        ),
                        scrollDirection: Axis.vertical,
                      );
                    }
                  },
                )),
    );
  }

  Widget _headerCoursel(List<SliderInfo> sliderInfo) {
    return CarouselSlider(
      height: double.infinity,
      items: sliderInfo.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String sessionId = prefs.get('hasSessionId'); // True
                  if (i.product_id != '0') {
                    productNew = await helpersApi.fetchPrdouctById(
                        i.product_id, sessionId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: true,
                        settings: RouteSettings(name: "single_product"),
                        builder: (BuildContext context) => SingleProduct(
                          productNew,
                          false,
                          null,
                          null,
                          null,
                          null
                        ),
                      ),
                    );
                    Navigator.popUntil(
                        context, ModalRoute.withName("single_product"));
                  } else if (i.category_id != '0') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: true,
                        settings: RouteSettings(name: "category"),
                        builder: (context) => HomeProduct(
                            sessionId: sessionId,
                            idComing: i.category_id,
                            nameCategory: i.title,
                          currIndex :0
                        ),
                      ),
                    );
                    Navigator.popUntil(
                        context, ModalRoute.withName("category"));
                  } else if (i.link != '') {
                    _launchURL('${i.link}');
                  }
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.28,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider('$imagesUrl${i.pic}'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: ScreenUtileColors.mainBlue,
                          child: Center(
                            child: Text(
                              i.title,
                              style: TextStyle(color: Colors.white, fontSize: 18 ,),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
//                      SizedBox(
//                        child: Container(
//                          height:40,
//                          color: ScreenUtileColors.mainBlue,
//                          child: Center(
//                            child: Text(
//                              i.title,
//                              style: TextStyle(color: Colors.white, fontSize: 18 ,),
//                              textAlign: TextAlign.justify,
//                            ),
//                          ),
//                        ),
//                      )
//                    Container(
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: CachedNetworkImageProvider('$imagesUrl${i.pic}'),
//                            fit: BoxFit.cover),
//                      ),
//                      width: double.infinity,
//                      child: Stack(
//                        children: <Widget>[
//                          Positioned(
//                            bottom: -40,
//                            right: 0,
//                            left: 0,
//                            child: Container(
//                              //    margin: EdgeInsets.only(top: 20),
//                              height: 40,
//                              color: ScreenUtileColors.mainBlue,
//                              child: Center(
//                                child: Text(
//                                  i.title,
//                                  style: TextStyle(color: Colors.white, fontSize: 18 ,),
//                                  textAlign: TextAlign.justify,
//                                ),
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
                    ],
                  ),
                ));
          },
        );
      }).toList(),
//      onPageChanged: (i){
//        setState(() {
//          sliderTitle = sliderInfo[i].title;
//        });
//      },
      aspectRatio: 16 / 9,
      viewportFraction: 1.0,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 6),
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _categoryGrid(
      BuildContext context, List<Category> categories, int orientation) {
    return GridView.builder(
      // reverse: true,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: orientation,
      ),
      controller: ScrollController(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            String idSelected = categories[index].id.toString();
            String serviceName = categories[index].title;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.get('hasSessionId');
            SharedPreferences serviceId = await SharedPreferences.getInstance();
            serviceId.setString('serviceId', idSelected);
            switch (categories[index].type) {
              case 'invoice':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "invoice"),
                    builder: (BuildContext context) => OnPagingFoater(),
                  ),
                );
                Navigator.popUntil(context, ModalRoute.withName("invoice"));
                break;
              case 'pharmacy':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "pharmacy"),
                    builder: (BuildContext context) => OnPagingPharmacy(),
                  ),
                );
                Navigator.popUntil(context, ModalRoute.withName("pharmacy"));

                break;
              case 'category':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "category"),
                    builder: (BuildContext context) => HomeProduct(
                      sessionId: sessionId,
                      idComing: idSelected,
                      nameCategory: categories[index].title,
                      isHasSubCategory: categories[index].has_sub_categories,
                        currIndex :0
                    ),
                  ),
                );
                Navigator.popUntil(context, ModalRoute.withName("category"));
                break;
              case 'service_categories':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "service_categories"),
                    builder: (BuildContext context) => HomeService(
                      sessionId: sessionId,
                      idComing: categories[index].id.toString(),
                      nameComing: serviceName,
                      isHasUnit: categories[index].is_have_unites_in_final_page,
                      servicePic: categories[index].pic,
                    ),
                  ),
                );
                Navigator.popUntil(
                    context, ModalRoute.withName("service_categories"));

                break;
              case 'service_products':
                SharedPreferences category__Id =
                    await SharedPreferences.getInstance();
                category__Id.setString('category__Id', '0');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "service_products"),
                    builder: (context) => ProductsInServices(
                        '0',
                        categories[index].id.toString(),
                        serviceName,
                        categories[index].is_have_unites_in_final_page,
                        categories[index].pic,
                        sessionId,
                      0,
                      0,
                      true
                    ),
                  ),
                );
                Navigator.popUntil(
                    context, ModalRoute.withName("service_products"));
                break;
              case 'final_page':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: "final_page"),
                    builder: (context) => FinalPageScreen(
                      serviceIdComing: categories[index].id.toString(),
                      serviceNameComing: serviceName,
                      isHasUnitInFinalPage:
                          categories[index].is_have_unites_in_final_page,
                      serviceCover: categories[index].pic,
                    ),
                  ),
                );
                Navigator.popUntil(context, ModalRoute.withName("final_page"));
                break;
            }
          },
          child: Card(
            margin: EdgeInsets.all(0.0),
            child: CachedNetworkImage(
              imageUrl: "$imagesUrl${categories[index].pic}",
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
                    '${categories[index].title}',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
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
      },
      itemCount: categories.length,
    );
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
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => MyHomePage()));
              })
        ],
      ),
    );
  }

  Future<bool> _onPressedBack() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('هل تريد الخروج من التطبيق'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('لا'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('نعم'),
              ),
            ],
          ),
        ) ??
        false;
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
                    builder: (BuildContext context) =>
                        CartScreenTest(sessionId)));
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
                                CartScreenTest(sessionId)));
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
      if (phoneNumber != "") {
        appBarTitle = new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "ديليفري أون لاين",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(
              '$phoneNumber',
              style: TextStyle(fontSize: 14),
            )
          ],
        );
      } else {
        appBarTitle = new Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "ديليفري أون لاين",
            style: TextStyle(fontSize: 16),
          ),
        );
      }
      /*
      appBarTitle = new StreamBuilder(
          stream: contactUsBloc.mainSettingStream,
          builder: (BuildContext context,
              AsyncSnapshot<MainSetting> snapShotSetting) {
            switch (snapShotSetting.connectionState) {
              case ConnectionState.none:
                error("none");
                break;
              case ConnectionState.waiting:
                contactUsBloc.fetchMainSetting.add('0');
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapShotSetting.data.phone != '') {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "ديليفري أون لاين",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${snapShotSetting.data.phone}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  );
                } else {
                  return Text(
                    "ديليفري أون لاين",
                  );
                }
                break;
            }
            return Container();
          });*/
      _isSearching = false;
      _searchController.clear();
    });
  }
}
