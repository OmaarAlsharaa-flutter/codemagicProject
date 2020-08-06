import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';


class OnPagingFoate extends StatefulWidget {
  @override
  _OnPagingFoateState createState() => _OnPagingFoateState();
}

class _OnPagingFoateState extends State<OnPagingFoate> {
  ScreenConfig screenConfig ;
  WidgetSize widgetSize;
  Image img;


  double quantity = 1.0;
  double product_price = 120;
  double total ;

  getTotal(){
    setState(() {
      total = quantity * product_price;
    });
  }


  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);




    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _firstPage(),
          _secondPage(),
        ],

      ),
    );
  }
  Widget _firstPage(){
    return new Material(
      child: new Container(
          child: new Center(
            child: new ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                _myTitle(),
                SizedBox(
                  height: 10,
                ),
                _allMealsList(),
              ],
            ),
          )),
    );
  }

  Widget _secondPage(){
    return Scaffold(
      appBar: AppBar(
        title: Text("الرجاء إكمال المعلومات"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white12,
        child: SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:40 ,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Center(
                      child: Icon(
                        Icons.person,
                        color: ScreenUtileColors.mainBlue,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Center(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'الاسم الثلاثي الكامل',
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.zero,
                                right: Radius.zero,
                              ),
                              borderSide: BorderSide(
                                  color: ScreenUtileColors.mainBlue,
                                  width: 0.5,
                                  style: BorderStyle.solid
                              ),
                            ),
                            labelStyle: TextStyle(
                                fontSize: widgetSize.titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Center(
                      child: Icon(
                        Icons.place,
                        color: ScreenUtileColors.mainBlue,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Center(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'العنوان بالتفصيل',
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.zero,
                                right: Radius.zero,
                              ),
                              borderSide: BorderSide(
                                  color: ScreenUtileColors.mainBlue,
                                  width: 0.5,
                                  style: BorderStyle.solid
                              ),
                            ),
                            labelStyle: TextStyle(
                                fontSize: widgetSize.titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Center(
                      child: Icon(
                        Icons.phone,
                        color: ScreenUtileColors.mainBlue,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Center(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'رقم الموبايل',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.zero,
                                right: Radius.zero,
                              ),
                              borderSide: BorderSide(
                                  color: ScreenUtileColors.mainBlue,
                                  width: 0.5,
                                  style: BorderStyle.solid
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text("تحويل وحدات إختياري",
                style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 15.0,
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Center(
                      child: Icon(
                        Icons.phone,
                        color: ScreenUtileColors.mainBlue,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Center(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'رقم الموبايل',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.zero,
                                right: Radius.zero,
                              ),
                              borderSide: BorderSide(
                                  color: ScreenUtileColors.mainBlue,
                                  width: 0.5,
                                  style: BorderStyle.solid
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Container(
                    height: 40.0,
                    width: 150,
                    child: RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> _secondPage()));
                      },
                      child: Center(
                        child:  Text("إرسال الطلب",
                          style: TextStyle(
                            color: ScreenUtileColors.fontColor,
                          ),
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myTitle() {
    return new SizedBox(
      child: new Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(width: 10, color: Colors.lightBlueAccent))),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Text(
                'مطعم فلان',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
      width: 350,
    );
  }

  Widget _allMealsList() {
    return new SizedBox(
      child: new Container(
        width: 350,
        height: MediaQuery.of(context).size.height,
        child: new ListView(
          children: <Widget>[
            _getMeals2(
                "كباب ", " Burger ", "assests/images/resturant.jpg"),
            _getMeals2(
                "شاورما ", " Burger2 ", "assests/images/resturant.jpg"),
            _getMeals2(
                "كريسبي ", " Burger3 ", "assests/images/resturant.jpg"),
          ],
        ),
      ),
    );
  }

  Widget _getMeals2(String dateMale, String mealName, String mealPhoto) {
    return new SizedBox(
      child: new Card(
        color: ScreenUtileColors.mainBlue,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width * 0.1,),

            Container(
              child: new Text(
                dateMale,
                style: TextStyle(fontSize: 20 , color: ScreenUtileColors.fontColor),
              ),
            ),
            SizedBox(width: 60,),
            Flexible(
              child: Container(
                child: Align(
                  alignment:Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.add_circle,color: ScreenUtileColors.fontColor) , onPressed: (){
                        setState(() {
                          quantity++;
                          getTotal();
                        });
                      }),
                      Container(child: Text("$quantity",style: TextStyle(color: ScreenUtileColors.fontColor),),),
                      IconButton(icon: Icon(Icons.do_not_disturb_on,color: ScreenUtileColors.fontColor) , onPressed: (){
                        setState(() {
                          if(quantity >1)
                            quantity--;
                          getTotal();
                        });
                      }),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      width: 350,
      height: 100,
    );
  }
}


