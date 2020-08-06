import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/product/home_product_bloc.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'completeResturantInfoScreen.dart';

class FoodInResturant extends StatefulWidget {
  final String idComing;
  final String resturant_name;
  FoodInResturant(this.idComing , this.resturant_name);
  @override
  _FoodInResturantState createState() => _FoodInResturantState();
}

class _FoodInResturantState extends State<FoodInResturant> {
  var helpersApi = new HelpersApi();
  HomeProductBloc homeProductBloc;
  String imagesUrl = ApiUtil.imagesUrl;
  double startVal;

  _addProduct(List<Product> products, int index, double incValue) {
    setState(() {
      productsOnCart = [];
      if (double.tryParse(products[index].quantity) >
          products[index].startFoodQuantityValue) products[index].startFoodQuantityValue += incValue;
    });
  }

  _subProduct(List<Product> products, int index, double decValue) {
    setState(() {
      productsOnCart = [];
      if (products[index].startFoodQuantityValue > 0)
        products[index].startFoodQuantityValue -= decValue;
    });
  }

  List<double> quantitesList;
  List<Map<String, dynamic>> productsOnCart = [];
  Product product;
  Map<String, dynamic> test1;
  double editQuantity;

  @override
  void initState() {
    homeProductBloc = HomeProductBloc();
    super.initState();
  }

  @override
  void dispose() {
    homeProductBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("${widget.resturant_name}"),
        centerTitle: false,
      ),
      body: Container(
        child: StreamBuilder(
          stream: homeProductBloc.productsStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return error("No Thing Working");
                break;
              case ConnectionState.waiting:
                homeProductBloc.fetchProduct.add(widget.idComing);
                return loading();
                break;
              case ConnectionState.done:
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return error(snapshot.error.toString());
                } else {
                  if (!snapshot.hasData) {
                    return error("No Data Returned");
                  } else {
                    return Stack(
                      children: <Widget>[
                        ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, position) {
                              //print(snapshot.data[position].quantity);
                              //print(snapshot.data[position].quantity_type);
                              if (snapshot.data[position].quantity_type ==
                                  'BOX') {
                                startVal = 1.0;
                              } else {
                                startVal = 0.5;
                              }
                              productsOnCart.add({
//                                "resturant_name": widget.resturant_name,
                                "food_name": snapshot.data[position].title,
                                "price": snapshot.data[position].price,
                                "quantity": snapshot.data[position].startFoodQuantityValue,
                              });

                              return Card(
                                margin: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                            "$imagesUrl${snapshot.data[position].pic}"),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(
                                        width: 25.0,
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Text(
                                              snapshot.data[position].title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            (snapshot.data[position]
                                                    .price_visible)
                                                ? Text(snapshot
                                                    .data[position].price)
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text("الكمية"),
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
//                                                      productsOnCart = [];
                                                      _addProduct(snapshot.data,
                                                          position, startVal);
                                                    }),
                                                new Text(
                                                    '${snapshot.data[position].startFoodQuantityValue.toString()}'),
                                                new IconButton(
                                                    icon: Icon(Icons
                                                        .do_not_disturb_on),
                                                    onPressed: () {
//                                                      productsOnCart = [];
                                                      _subProduct(snapshot.data,
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
                              );
                            }),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          left: 10,
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
                              print(" First Class $productsOnCart");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteInfoResturantScreen(
                                              snapshot.data, productsOnCart,widget.resturant_name)));
                            },
                          ),
                        ),
                      ],
                    );
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
}
