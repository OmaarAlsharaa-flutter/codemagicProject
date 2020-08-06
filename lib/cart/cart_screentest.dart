import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deleteFromCartModel.dart';
import 'final_step_to_buy.dart';



class CartScreenTest extends StatefulWidget {
  final String sessionId;

  CartScreenTest(this.sessionId);

  @override
  _CartScreenTestState createState() => _CartScreenTestState();
}

class _CartScreenTestState extends State<CartScreenTest> with TickerProviderStateMixin<CartScreenTest>{

  String imagesUrl = ApiUtil.imagesUrl;
  HelpersApi helpersApi = new HelpersApi();
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  DeleteFromCart deleteFromCart;
  double total;
  double totalMount = 0 ;
  List<CartModel> cartData = [];
  ScreenConfig screenConfig;
  WidgetSize widgetSize;


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
        showDialogNoInternet();
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
              builder: (context) => CartScreenTest(
                widget.sessionId
              )
          ));
        })],
      ),
    );
  }

  void getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.get('hasSessionId');
    List data = await helpersApi.fetchProductInCart(sessionId);
    for (int i = 0; i < data.length; i++) {
      setState(() {
        cartData.add(data[i]);
        totalMount += double.tryParse(cartData[i].product_price) * double.tryParse(cartData[i].requested_quantity);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    getCartData();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     screenConfig = new ScreenConfig(context);
     widgetSize = new WidgetSize(screenConfig);

    return Scaffold(
      appBar: AppBar(
          title: new Text('السلة'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
          )
      ),
      body: FutureBuilder(
        future: helpersApi.fetchProductInCart(widget.sessionId),
        builder: (context , AsyncSnapshot<List<CartModel>> snapShot){
          switch (snapShot.connectionState) {
            case ConnectionState.none:
              return error("No Thing Working");
              break;
            case ConnectionState.waiting:
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
                  return itemsInCart(snapShot.data);
                }
              }
              break;
          }
          return Container();
        },
      ),
    );
  }

  Widget _noData(){
    return Container(
      color: Colors.white,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assests/images/empty_cart.jpg"),height: 200,width:300 ,),
                SizedBox(height: 8,),
                Text("لا يوجد عناصر في السلة ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black45 ),),
              ],
            ),
          ),
        );
  }
  Widget itemsInCart (List<CartModel> cartModel){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: cartModel == null ? 0 : cartModel.length,
                itemBuilder: (BuildContext context, i) {
                  return itemCard(cartModel,i);
                },
              ),
              Positioned(
                bottom: 0,
                right: MediaQuery.of(context).size.width *0.4,
                left: MediaQuery.of(context).size.width *0.4,
                child: RaisedButton(
                  color: ScreenUtileColors.mainBlue,
                  child: Text("شراء",style: TextStyle(color: ScreenUtileColors.fontColor),),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: 'toFinal'),
                            builder: (BuildContext context)=>
                                FinalStepToBuy()
                        )
                    );
                    Navigator.popUntil(context, ModalRoute.withName('toFinal'));
                  },
                ),
              ),
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Center(
//                      child: RaisedButton(
//                        color: ScreenUtileColors.mainBlue,
//                        child: Text("شراء",style: TextStyle(color: ScreenUtileColors.fontColor),),
//                        onPressed: (){
//                          Navigator.push(context,
//                              MaterialPageRoute(
//                                settings: RouteSettings(name: 'toFinal'),
//                                  builder: (BuildContext context)=>
//                                  FinalStepToBuy()
//                              )
//                          );
//                          Navigator.popUntil(context, ModalRoute.withName('toFinal'));
//                        },
//                      ),
//                    ),
//                //    Text(" المجموع : $totalMount ليرة سورية ")
//                  ],
//                ),
//              )
            ],
          ),
    );
  }
  Widget itemCard(List<CartModel> cartModel,i){
    double newTotalMount;
    List<CartModel> newcartModel = [];
    total = double.tryParse(cartModel[i].product_price) * double.tryParse(cartModel[i].requested_quantity);
    double quantity;
    return Padding(
      padding: const EdgeInsets.only(top: 6.0,bottom: 6.0,right: 8.0 , left: 8.0),
      child: Container(
        height: 150 ,
        child: new Card (
          elevation: 4,
          child: Row(
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
             // CircleAvatar( radius: 45 ,backgroundImage: NetworkImage('$imagesUrl${cartModel[i].product_pic}'),backgroundColor: Colors.transparent,),
              Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: "$imagesUrl${cartModel[i].product_pic}",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
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
              SizedBox(width: 20.0,),
              Flexible(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Text(cartModel[i].product_title ,),
                    SizedBox(height: 20.0,),
                    Flexible(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.add_circle) ,
                                onPressed: ()async{
                                  (cartModel[i].quantity_type=='KG')? quantity = 0.5 : quantity = 1.0;
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String sessionId = prefs.get('hasSessionId');
                                  await helpersApi.editQuantityInCart(cartModel[i].product_id, quantity.toString(), sessionId);
                                  newcartModel = await helpersApi.fetchProductInCart(sessionId);
                                  newTotalMount = double.tryParse(cartModel[i].product_price) * quantity;
                                  setState(() {
                                    cartModel = newcartModel;
                                    totalMount = totalMount + newTotalMount;
                                  });
                                }),
                            Flexible(child: Container(child: Text("${cartModel[i].requested_quantity.toString()}"),)),
                            IconButton(icon: Icon(Icons.do_not_disturb_on) ,
                                onPressed: () async {
                                  if((cartModel[i].quantity_type=='KG' && cartModel[i].requested_quantity.toString() == "0.5")
                                      ||(cartModel[i].quantity_type=='BOX' && cartModel[i].requested_quantity.toString() == "1")){
                                  }else{
                                    (cartModel[i].quantity_type=='KG')? quantity = - 0.5 : quantity = - 1.0;
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String sessionId = prefs.getString('hasSessionId');
                                    await helpersApi.editQuantityInCart(cartModel[i].product_id, quantity.toString(), sessionId);
                                    newcartModel = await helpersApi.fetchProductInCart(sessionId);
                                    newTotalMount = double.tryParse(cartModel[i].product_price) * quantity;
                                    setState(() {
                                      cartModel = newcartModel;
                                      totalMount = totalMount + newTotalMount;
                                    });
                                  }

//                                setState(() {
//                                  if(quantity >1)
//                                  quantity--;
//                                  getTotal();
//                                });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Column(
                children: <Widget>[
                  SizedBox(height: 8,),
                  Align(
                      alignment:Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String sessionId = prefs.get('hasSessionId');
                          var response = await helpersApi.deleteProductFromCart(sessionId, cartModel[i].item_in_cart_id);
                          if(response.errors_code.length > 0){
                            Fluttertoast.showToast(msg: response.result);
                          }else{
                            Fluttertoast.showToast(msg: response.result);
                            setState(() {
                              cartModel.remove(cartModel[i]);
                              totalMount = totalMount - total;
                              // totalMount -= double.tryParse(cartModel[i].product_price) * double.tryParse(cartModel[i].requested_quantity);
                            });
                          }
                        },
                        color: Colors.red,)),
                //  SizedBox (height: 16,),
                //  Text(" (${cartModel[i].requested_quantity} * ${cartModel[i].product_price})"),
                //  Text("${total.toString()} "),
                //  Text("ليرة سورية"),
                ],
              ),
              SizedBox (width: MediaQuery.of(context).size.width * 0.03,),
            ],
          ),
        ),
      ),
    );
  }
}




