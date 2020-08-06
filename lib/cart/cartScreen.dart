import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/cart/cartmodel.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deleteFromCartModel.dart';
import 'final_step_to_buy.dart';



class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin<CartScreen>{

  String imagesUrl = ApiUtil.imagesUrl;
  List<CartModel> cartData = [];
  HelpersApi helpersApi = new HelpersApi();
  String key_Code = '7bea9fe7d1bffe42150e13893d5ad971';
  DeleteFromCart deleteFromCart;

  double total;
  double totalMount = 0 ;

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
    getCartData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: new Text('السلة'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
          )

      ),
      body:(cartData.length != 0 )? Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: cartData == null ? 0 : cartData.length,
            itemBuilder: (BuildContext context, i) {
              return itemCard(i);
            },
          ),
          Positioned(
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(right: 16.0,left: 16.0,),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      child: Text("شراء",style: TextStyle(color: ScreenUtileColors.fontColor),),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context)=>
                            FinalStepToBuy()));
                      },
                    ),
                    Text(" المجموع : $totalMount ليرة سورية ")
                  ],
                ),
              ),
            ),
          )
        ],
      ):Container(
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
      )
    );
  }

  Widget itemCard(i){
     double newTotalMount;
     List<CartModel> newCartData = [];
      total = double.tryParse(cartData[i].product_price) * double.tryParse(cartData[i].requested_quantity);
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
              CircleAvatar( radius: 40 ,backgroundImage: NetworkImage('$imagesUrl${cartData[i].product_pic}'),backgroundColor: Colors.transparent,),
              SizedBox(width: 20.0,),
              Flexible(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Text(cartData[i].product_title),
                    SizedBox(height: 20.0,),
                     Flexible(
                       child: Container(
                         child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.add_circle) ,
                               // key:  _refreshPageKey,
                                onPressed: ()async{
                                (cartData[i].quantity_type=='KG')? quantity = 0.5 : quantity = 1.0;
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String sessionId = prefs.get('hasSessionId');
                                helpersApi.editQuantityInCart(cartData[i].product_id, quantity.toString(), sessionId);
                                newCartData = await helpersApi.fetchProductInCart(sessionId);
                                newTotalMount = double.tryParse(cartData[i].product_price) * quantity;
                                setState(() {
                                  cartData = newCartData;
                                  totalMount = totalMount + newTotalMount;
                                });
                              }),
                              Flexible(child: Container(child: Text("${cartData[i].requested_quantity.toString()}"),)),
                              IconButton(icon: Icon(Icons.do_not_disturb_on) ,
                             //    key:  _refreshPageKey,
                                 onPressed: () async {
                                (cartData[i].quantity_type=='KG')? quantity = - 0.5 : quantity = - 1.0;
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String sessionId = prefs.get('hasSessionId');
                                helpersApi.editQuantityInCart(cartData[i].product_id, quantity.toString(), sessionId);
                                newCartData = await helpersApi.fetchProductInCart(sessionId);
                                newTotalMount = double.tryParse(cartData[i].product_price) * quantity;
                                setState(() {
                                  cartData = newCartData;
                                  totalMount = totalMount + newTotalMount;
                                });
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
                              helpersApi.deleteProductFromCart(sessionId, cartData[i].item_in_cart_id);
                              setState(() {
                                cartData.remove(cartData[i]);
                                totalMount = totalMount - total;
                               // totalMount -= double.tryParse(cartData[i].product_price) * double.tryParse(cartData[i].requested_quantity);
                              });
                              print(sessionId);
                            },
                            color: Colors.red,)),
                      SizedBox (height: 16,),
                      Text(" (${cartData[i].requested_quantity} * ${cartData[i].product_price})"),
                      Text("${total.toString()} "),
                      Text("ليرة سورية"),
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

//new ListTile(
//title: new Text(data[i]["name"]["first"]),
//subtitle: new Text(data[i]["phone"]),
//leading: new CircleAvatar(
//backgroundImage: new NetworkImage(data[i]["picture"]["thumbnail"]),
//),
//onTap: (){
//Navigator.push(context,
//new MaterialPageRoute(builder: (BuildContext context)=>
//new SecondHttpPage(data[i])));
//},
//)



