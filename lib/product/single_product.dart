import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/addcartresult.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/exceptionStatus/all_exception.dart';
import 'package:delevery_online/product/home_product.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delevery_online/public_methods.dart';

class SingleProduct extends StatefulWidget {
  final dynamic productComing;
  final bool isFromHomeProduct;
  final String idComing;
  final String sessionId;
  final String nameCategory;
  final bool isHasSubCategory;
  final int indexComeFrom;
  //final String testId;


  SingleProduct(this.productComing, this.isFromHomeProduct, this.sessionId, this.nameCategory, this.isHasSubCategory,  this.idComing , {this.indexComeFrom});
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  AddCartResult cartModelResult;
  HelpersApi helpersApi;
  String result;
  Product product;
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  String imagesUrl = ApiUtil.imagesUrl;
  double quantity;
  double startVal;
  getStartVal() {
    if (widget.productComing.quantity_type == 'BOX') {
      setState(() {
        startVal = 1.0;
        quantity = startVal;
      });
    } else if (widget.productComing.quantity_type == 'KG') {
      setState(() {
        startVal = 0.5;
        quantity = startVal;
      });
    }
  }

  double total;
  getTotal() {
    setState(() {
      total = quantity * double.tryParse(widget.productComing.price);
    });
  }

  Future<Product> fetchProductInfo() async {
    //  await checkInternet();
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'product_info',
      'key_code': '$key_Code',
      'id': widget.productComing
    });
    switch (response.statusCode) {
      case 200:
        var body = jsonDecode(response.body);
        print(body);
        Product products = Product.fromJson(body);
        setState(() {
          product = products;
        });
        return product;
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  Future<AddCartResult> fetchResultAddToCart(String product_id, String quantity, String session_id) async {
    //  await checkInternet();
    String url = ApiUtil.apiUrl;
    http.Response response = await http.post(url, body: {
      'action': 'add_to_cart',
      'key_code': '$key_Code',
      'product_id': product_id,
      'quantity': quantity,
      'session_id': session_id
    });
    switch (response.statusCode) {
      case 200:
        var body = jsonDecode(response.body);
        print(body);
        AddCartResult cartModel = AddCartResult.fromJson(body);
        setState(() {
          cartModelResult = cartModel;
        });
        print(cartModelResult.result);
        return cartModel;
        break;
      case 404:
        throw ResouceNotFound('product');
        break;
      case 301:
      case 302:
      case 303:
        throw RedirectionFound();
        break;
      default:
        return null;
        break;
    }
  }

  @override
  void initState() {
    getStartVal();
    getTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // textDirection: TextDirection.rtl,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: (widget.productComing.pic != null)
                        ? "$imagesUrl${widget.productComing.pic}"
                        : "${product.feuatredImage()}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
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
                  height: 20,
                ),
                title(),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Align(
                    child: Text(
                      "الوصف : ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
                description(),
                SizedBox(
                  height: 30,
                ),
                quantityDesign(),
                SizedBox(
                  height: 8,
                ),
                footer()
              ],
            ),
          ),
        ),
        Positioned(
            top: 18.0,
            right: 10.0,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (widget.isFromHomeProduct == true)?() {
                  Navigator.of(context).pop(true);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => HomeProduct(
                    currIndex: widget.indexComeFrom,
                    idComing: widget.idComing,
                    isHasSubCategory: widget.isHasSubCategory,
                    nameCategory: widget.nameCategory,
                    sessionId: widget.sessionId,
                  )));
                }:(){
                  Navigator.of(context).pop(true);
                },
                iconSize: 30,
                color: ScreenUtileColors.mainBlue,
              ),
            )),
      ],
    ));
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 2.0,
      ),
      child: Text(
        "${widget.productComing.title}",
        textAlign: TextAlign.right,
        style: TextStyle(color: Color(0xFF6F8398), fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, right: 16.0, left: 16.0),
      child: Html(
          data: '${widget.productComing.description}',
          customTextAlign: (dom.Node node) {
            if (node is dom.Element) {
              switch (node.localName) {
                case "p":
                  return TextAlign.justify;
              }
            }
          }),
      //textAlign: TextAlign.justify,
      //style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
    );
  }

  Widget quantityDesign() {
    if (widget.productComing.is_in_cart != true) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (widget.productComing.price_visible == false)?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
        children: <Widget>[

          (widget.productComing.price_visible == true)?
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ):Container(),
          (widget.productComing.price_visible == true)?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("الكمية"),
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        setState(() {
                          if (double.tryParse(widget.productComing.quantity) >
                              quantity) quantity += startVal;
                          getTotal();
                        });
                      }),
                  Container(
                    child: Text("$quantity"),
                  ),
                  // ${quantity}
                  IconButton(
                      icon: Icon(Icons.do_not_disturb_on),
                      onPressed: () {
                        setState(() {
                          if (quantity > startVal)
                            quantity -= startVal;
                          else
                            quantity = startVal;
                          getTotal();
                        });
                      }),
                ],
              ),
            ],
          ):Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("الكمية"),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          setState(() {
                            if (double.tryParse(widget.productComing.quantity) >
                                quantity) quantity += startVal;
                            getTotal();
                          });
                        }),
                    Container(
                      child: Text("$quantity"),
                    ),
                    // ${quantity}
                    IconButton(
                        icon: Icon(Icons.do_not_disturb_on),
                        onPressed: () {
                          setState(() {
                            if (quantity > startVal)
                              quantity -= startVal;
                            else
                              quantity = startVal;
                            getTotal();
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),

          (widget.productComing.price_visible == true)?
          SizedBox(
            width: 20,
          ):Container(),
          (widget.productComing.price_visible == true)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("($quantity * ${widget.productComing.price})"),
                    Text("$total "),
                    Text("ليرة سورية"),
                  ],
                )
              : Container(),
          (widget.productComing.price_visible == true)?
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ):Container(),
        ],
      );
    } else {
      return Container(
        child: Center(
          child: Text("العنصر موجود بالسلة"),
        ),
      );
    }
  }
  Widget footer() {
    if (widget.productComing.is_in_cart) {
      return Center(
        child: FlatButton(
          child: Text(
            "الذهاب إلى السلة",
            style: TextStyle(color: ScreenUtileColors.fontColor),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.get('hasSessionId');

            Navigator.of(context).push(
                MaterialPageRoute(
                    maintainState: true,
                    settings: RouteSettings(name: 'goToCart'),
                    builder: (BuildContext context)  => CartScreenTest(sessionId)
                )
            );
            Navigator.popUntil(context, ModalRoute.withName('goToCart'));
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => CartScreenTest(sessionId)),
//            );
          },
          color: ScreenUtileColors.mainBlue,
        ),
      );
    } else {
      return Center(
        child: FlatButton(
          child: Text(
            "إضافة إلى السلة",
            style: TextStyle(color: ScreenUtileColors.fontColor),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.get('hasSessionId');
            PublicMethods.startConnectionDialog(context, 'الرجاء الانتظار');
            var response = await fetchResultAddToCart(
                widget.productComing.product_id,
                quantity.toString(),
                sessionId);
            if (response.errors_code.length > 0) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: response.result);
            } else {
              Fluttertoast.showToast(msg: "تمت إضافة العنصر إلى السلة");
              Navigator.pop(context);
              setState(() {
                widget.productComing.is_in_cart = true;
              });
            }

//            fetchResultAddToCart(widget.productComing.product_id, quantity.toString(), sessionId);
          },
          color: ScreenUtileColors.mainBlue,
        ),
      );
    }
  }
}

// https://stackoverflow.com/questions/51019291/how-can-i-add-item-number-on-the-cart-icon-at-at-appbar-icon-in-flutter-and-how
