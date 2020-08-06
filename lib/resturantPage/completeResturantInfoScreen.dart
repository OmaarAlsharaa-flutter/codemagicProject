import 'dart:async';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public_methods.dart';

class CompleteInfoResturantScreen extends StatefulWidget {
  final List<Map<String, dynamic>> productsOnCart ;
  final List<Product> products;
  String resturantName;

  CompleteInfoResturantScreen(this.products , this.productsOnCart ,this.resturantName);

  @override
  _CompleteInfoResturantScreenState createState() =>
      _CompleteInfoResturantScreenState();
}

class _CompleteInfoResturantScreenState extends State<CompleteInfoResturantScreen> {
  var helpersApi = new HelpersApi();
  TextEditingController _userNameController;
  TextEditingController _addressController;
  TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  String _userName;
  String _address;
  String _phoneNumber;
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  Image img;
  String _setPlace;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String _timeSelected;
  String _dateSelected;
  List<Map<String , dynamic>> foodDetails = [] ;



  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2021));

  Future<TimeOfDay> _selectTime(BuildContext context) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
      );

  List<Map<String , dynamic>> getFoodDetails (){
    for (int i = 0 ; i<widget.products.length ; i++){
      if(widget.productsOnCart[i]['quantity'] != 0.0){
        setState(() {
          foodDetails.add({
            "food_name" : widget.productsOnCart[i]['food_name'],
            "price" : widget.productsOnCart[i]['price'],
            "quantity" : widget.productsOnCart[i]['quantity'],
            "break":"break",
          }
          );
        });
      }

    }
    print("Food Deatails $foodDetails");
      return foodDetails;
  }


  @override
  void initState() {
    getFoodDetails ();
    _userNameController = TextEditingController();
    _addressController =  TextEditingController();
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    print("Second Class ${widget.productsOnCart}");
    return Scaffold(
      appBar: AppBar(
        title: Text("الرجاء إكمال المعلومات"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white12,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
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
                          Icons.person,
                          color: ScreenUtileColors.mainBlue,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        child: Center(
                          child: TextFormField(
                            controller: _userNameController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'الرجاء إدخال الاسم الثلاثي';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'الاسم الثلاثي',
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.zero,
                                  right: Radius.zero,
                                ),
                                borderSide: BorderSide(
                                    color: ScreenUtileColors.mainBlue,
                                    width: 0.5,
                                    style: BorderStyle.solid),
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
                  height: 25.0,
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
                          child: TextFormField(
                            controller: _addressController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'الرجاء إدخال العنوان بالتفصيل';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'الحي،الشارع،البناء',
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.zero,
                                  right: Radius.zero,
                                ),
                                borderSide: BorderSide(
                                    color: ScreenUtileColors.mainBlue,
                                    width: 0.5,
                                    style: BorderStyle.solid),
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
                  height: 25.0,
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
                          child: TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'الرجاء إدخال رقم الموبايل';
                              }
                              return null;
                            },
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
                                    style: BorderStyle.solid),
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
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Radio(
                            value: 'إرسال الطلب إلى المنزل',
                            groupValue: _setPlace,
                            onChanged: (String val) {
                              setPlaceValue(val);
                            },
                            activeColor: ScreenUtileColors.mainBlue,
                          ),
                          Text(
                            'إرسال الطلب إلى المنزل',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Radio(
                                value: 'الحجز في المطعم',
                                groupValue: _setPlace,
                                onChanged: (String val) {
                                  setPlaceValue(val);
                                },
                                activeColor: ScreenUtileColors.mainBlue,
                              ),
                              Text(
                                'الحجز في المطعم',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                color: (_setPlace == 'إرسال الطلب إلى المنزل' )?  Colors.grey : ScreenUtileColors.mainBlue,
                                child: Text(
                                  " التاريخ  ",
                                  style: TextStyle(
                                      color: ScreenUtileColors.fontColor),
                                ),
                                onPressed: (_setPlace != 'إرسال الطلب إلى المنزل' )?() async {
                                  final selectedDate = await _selectDate(context);
                                  if (selectedDate == null) return;
                                  print(selectedDate);
                                  setState(() {
                                    this._date = DateTime(selectedDate.year,
                                        selectedDate.month, selectedDate.day);
                                  });
                                }:(){}
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              RaisedButton(
                                color: (_setPlace == 'إرسال الطلب إلى المنزل' )?  Colors.grey : ScreenUtileColors.mainBlue,
                                child: Text(
                                  " الوقت ",
                                  style: TextStyle(
                                      color: ScreenUtileColors.fontColor),
                                ),
                                onPressed: (_setPlace != 'إرسال الطلب إلى المنزل' )? () async {
                                  final selectedTime = await _selectTime(context);
                                  if (selectedTime == null) return;
                                  print(selectedTime);
                                  setState(() {
                                    this._time = TimeOfDay(
                                      hour: selectedTime.hour,
                                      minute: selectedTime.minute,
                                    );
                                  });
                                }:(){}
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                  child: (_date == null) ? Text(""): Text(
                                      "التاريخ ${_date.toString().substring(0, 10)}")),
                              SizedBox(
                                width: 30,
                              ),
                              (_time == null)? Text("") : Text(" الوقت ${_time.toString().substring(10,15)}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                      height: 40.0,
                      width: 150,
                      child: RaisedButton(
                        color: ScreenUtileColors.mainBlue,
                        onPressed: () async {
                          if(_setPlace == null){
                            Fluttertoast.showToast(msg: "الرجاء إختيار هل تريد إيصال الطلب إلى المنزل أو الحجز في المطعم ");
                          }else{
                            if( _setPlace == 'إرسال الطلب إلى المنزل' ){
                              _timeSelected = null;
                              _dateSelected = null;
                            }else{
                              _timeSelected = _time.toString().substring(10,15);
                              _dateSelected = _date.toString().substring(0, 10);
                            }
                            print("before $foodDetails");
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            String sessionId = prefs.get('hasSessionId');
                            if (_formKey.currentState.validate()) {
                              _userName = _userNameController.text.toString();
                              _address = _addressController.text.toString();
                              _phoneNumber = _phoneNumberController.text.toString();
                              List<Map<String, dynamic>> det = [
                                {"heading": "المعلومات الشخصية"},
                                {"user_name": _userName},
                                {"address": _address},
                                {"phone_Number": _phoneNumber},
                                {"new_line": "new_line"},
                                {"heading": "معلومات الحجز"},
                                {"place_type": _setPlace},
                                {"time": _timeSelected },
                                {"date": _dateSelected },
                                {"new_line": "new_line"},
                                {"heading": "الطلبات"},
                                {"resturant_name":widget.resturantName},
                                {"break":"break"},
                                {"details": foodDetails},

                              ];
                              var response = await helpersApi.addNewOrderDio(
                                  sessionId, "Restaurants", det, null);
                              if (response.errors_code.length > 0) {
                                Fluttertoast.showToast(msg: response.result);
                              } else {
                                PublicMethods.showCustomDialog(
                                    context, response.result);
                              }
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            "إرسال الطلب",
                            style: TextStyle(
                              color: ScreenUtileColors.fontColor,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  setPlaceValue(String val) {
    setState(() {
      _setPlace = val;
      print(_setPlace);
    });
  }
}
