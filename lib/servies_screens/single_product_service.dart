import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/addcartresult.dart';
import 'package:delevery_online/cart/cart_screentest.dart';
import 'package:delevery_online/exceptionStatus/all_exception.dart';
import 'package:delevery_online/product/home_product.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/servies_screens/products_in_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';

class SingleProductServies extends StatefulWidget {
  final dynamic productComing;

  //final String testId;


  SingleProductServies(this.productComing);
  @override
  _SingleProductServiesState createState() => _SingleProductServiesState();
}

class _SingleProductServiesState extends State<SingleProductServies> {
  AddCartResult cartModelResult;
  HelpersApi helpersApi;
  String result;
  Product product;
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  String imagesUrl = ApiUtil.imagesUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productComing.title),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: (){
//            Navigator.of(context).pop(true);
//            Navigator.push(context, new MaterialPageRoute(builder: (context) => ProductsInServices(
//
//            )));
//          },
//        ),
      ),
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
                  height: MediaQuery.of(context).size.width * 0.6,
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
              ],
            ),
          ),
        ),
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

}

// https://stackoverflow.com/questions/51019291/how-can-i-add-item-number-on-the-cart-icon-at-at-appbar-icon-in-flutter-and-how
