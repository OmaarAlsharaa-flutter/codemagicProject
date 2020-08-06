//import 'dart:convert';
//
//import 'package:delevery_online_test1/Model/unit_model.dart';
//import 'package:delevery_online_test1/api/helpersApi.dart';
//import 'package:delevery_online_test1/screens/screenUtilties/screen_utility_colors.dart';
//import 'package:delevery_online_test1/screens/screenUtilties/sizeconfigration.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//import '../public_methods.dart';
//
//class WheelScreen extends StatefulWidget {
//  @override
//  _WheelScreenState createState() => _WheelScreenState();
//}
//
//class _WheelScreenState extends State<WheelScreen> {
//  ScreenConfig screenConfig;
//  WidgetSize widgetSize;
//  final _formKey = GlobalKey<FormState>();
//  TextEditingController _userNameController;
//  TextEditingController _addressController;
//  TextEditingController _carTypeController;
//  TextEditingController _addressCarController;
//  TextEditingController _phoneNumberUnitsController ;
//
//
//  HelpersApi helpersApi = new HelpersApi();
//  List<UnitModel> unitData = [];
//  String selectedUnit = "" ;
//
//  bool isValueOfUnitSelected = false ;
//  void getListOfUnit() async {
//    List data = await helpersApi.getUnitsData();
//    print('unit data befor $unitData');
//    for (int i = 0; i < data.length; i++) {
//      setState(() {
//        unitData.add(data[i]);
//      });
//    }
//    print('unit data after ${unitData[0].unite_price}');
//  }
//
//  String _userName;
//  String _address;
//  String _carType;
//  String _addressCar;
//  String _phoneNumberUnitsString;
//
//  @override
//  void initState() {
//    _userNameController = TextEditingController();
//    _addressController = TextEditingController();
//    _carTypeController = TextEditingController();
//    _addressCarController = TextEditingController();
//    _phoneNumberUnitsController = TextEditingController();
//    getListOfUnit();
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _userNameController.dispose();
//    _addressController.dispose();
//    _carTypeController.dispose();
//    _addressCarController.dispose();
//    _phoneNumberUnitsController.dispose();
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    screenConfig = ScreenConfig(context);
//    widgetSize = WidgetSize(screenConfig);
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("دولابك ديليفري",),
//      ),
//      //resizeToAvoidBottomPadding: false,
//        body: new Container(
//          height: MediaQuery.of(context).size.height,
//          color: Colors.white12,
//          child: SingleChildScrollView(
//            child: new Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                _drawHeader(),
//                _drawForm(),
//                _drawUnits(),
//                SizedBox(
//                  height: 30.0,
//                ),
//                _drawBtnSend(),
//                SizedBox(
//                  height: 15.0,
//                ),
//                SizedBox(
//                  height: MediaQuery.of(context).size.height * 0.01,
//                )
//              ],
//            ),
//          ),
//        ));
//  }
//
//
//  Widget _drawHeader(){
//    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//            image: AssetImage("assests/images/Wheel.jpg"),
//            fit: BoxFit.cover
//        ),
//      ),
//      width: MediaQuery.of(context).size.width,
//      height:  MediaQuery.of(context).size.height *0.30,
//
//    );
//  }
//
//  Widget _drawForm(){
//    return Padding(
//      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//      child: Form(
//        key: _formKey,
//        child: Container(
//          //   padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//          child: new Column(
//            textDirection: TextDirection.rtl,
//            children: <Widget>[
//              Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.1,
//                    ),
//                    Center(
//                      child: Icon(
//                        Icons.person,
//                        color: ScreenUtileColors.mainBlue,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Flexible(
//                      child: Center(
//                        child: TextFormField(
//                          controller: _userNameController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'الرجاء إدخال الاسم الثلاثي';
//                            }
//                            return null;
//                          },
//                          textDirection: TextDirection.rtl,
//                          decoration: InputDecoration(
//                            labelText: 'الاسم الثلاثي',
//                            focusedBorder: UnderlineInputBorder(
//                              borderRadius: BorderRadius.horizontal(
//                                left: Radius.zero,
//                                right: Radius.zero,
//                              ),
//                              borderSide: BorderSide(
//                                  color: ScreenUtileColors.mainBlue,
//                                  width: 0.5,
//                                  style: BorderStyle.solid
//                              ),
//                            ),
//                            labelStyle: TextStyle(
//                                fontSize: widgetSize.titleFontSize,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.2,
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 15.0,
//              ),
//              Container(
//
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.1,
//                    ),
//                    Center(
//                      child: Icon(
//                        Icons.place,
//                        color: ScreenUtileColors.mainBlue,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Flexible(
//                      child: Center(
//                        child: TextFormField(
//                          controller: _addressController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'الرجاء إدخال العنوان بالتفصيل';
//                            }
//                            return null;
//                          },
//                          textDirection: TextDirection.rtl,
//                          decoration: InputDecoration(
//                            labelText: 'الحي،الشارع،البناء',
//                            focusedBorder: UnderlineInputBorder(
//                              borderRadius: BorderRadius.horizontal(
//                                left: Radius.zero,
//                                right: Radius.zero,
//                              ),
//                              borderSide: BorderSide(
//                                  color: ScreenUtileColors.mainBlue,
//                                  width: 0.5,
//                                  style: BorderStyle.solid
//                              ),
//                            ),
//                            labelStyle: TextStyle(
//                                fontSize: widgetSize.titleFontSize,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.2,
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 15.0,
//              ),
//              Container(
//
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.1,
//                    ),
//                    Center(
//                      child: Icon(
//                        Icons.directions_car,
//                        color: ScreenUtileColors.mainBlue,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Flexible(
//                      child: Center(
//                        child: TextFormField(
//                          controller: _carTypeController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'الرجاء إدخال نوع السيارة';
//                            }
//                            return null;
//                          },
//                          textDirection: TextDirection.rtl,
//                          decoration: InputDecoration(
//                            labelText: 'نوع السيارة',
//                            labelStyle: TextStyle(
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                            focusedBorder: UnderlineInputBorder(
//                              borderRadius: BorderRadius.horizontal(
//                                left: Radius.zero,
//                                right: Radius.zero,
//                              ),
//                              borderSide: BorderSide(
//                                  color: ScreenUtileColors.mainBlue,
//                                  width: 0.5,
//                                  style: BorderStyle.solid
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.2,
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 15.0,
//              ),
//              Container(
//
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.1,
//                    ),
//                    Center(
//                      child: Icon(
//                        Icons.place,
//                        color: ScreenUtileColors.mainBlue,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Flexible(
//                      child: Center(
//                        child: TextFormField(
//                          controller: _addressCarController,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'الرجاء إدخال مكان وجود السيارة';
//                            }
//                            return null;
//                          },
//                          textDirection: TextDirection.rtl,
//                          decoration: InputDecoration(
//                            labelText: 'مكان وجود السيارة',
//                            focusedBorder: UnderlineInputBorder(
//                              borderRadius: BorderRadius.horizontal(
//                                left: Radius.zero,
//                                right: Radius.zero,
//                              ),
//                              borderSide: BorderSide(
//                                  color: ScreenUtileColors.mainBlue,
//                                  width: 0.5,
//                                  style: BorderStyle.solid
//                              ),
//                            ),
//                            labelStyle: TextStyle(
//                                fontSize: widgetSize.titleFontSize,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.2,
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//  Widget _drawUnits(){
//    return Padding(
//      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          SizedBox(
//            height: 10.0,
//          ),
//          Text(
//            PublicMethods.unit,
//            style:
//            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//          ),
//          SizedBox(
//            height: 15.0,
//          ),
//          Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                SizedBox(
//                  width: MediaQuery.of(context).size.width * 0.1,
//                ),
//                Center(
//                  child: Icon(
//                    Icons.phone,
//                    color: ScreenUtileColors.mainBlue,
//                  ),
//                ),
//                SizedBox(
//                  width: 10.0,
//                ),
//                Flexible(
//                  child: Center(
//                    child: TextFormField(
//                      keyboardType: TextInputType.phone,
//                      controller: _phoneNumberUnitsController,
//                      textDirection: TextDirection.rtl,
//                      decoration: InputDecoration(
//                        labelText: 'رقم موبايل ',
//                        labelStyle: TextStyle(
//                            fontWeight: FontWeight.bold, color: Colors.grey),
//                        focusedBorder: UnderlineInputBorder(
//                          borderRadius: BorderRadius.horizontal(
//                            left: Radius.zero,
//                            right: Radius.zero,
//                          ),
//                          borderSide: BorderSide(
//                              color: ScreenUtileColors.mainBlue,
//                              width: 0.5,
//                              style: BorderStyle.solid),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  width: MediaQuery.of(context).size.width * 0.2,
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 15.0,
//          ),
//          Container(
//            height: 40,
//            child: Row(
//              children: <Widget>[
//                SizedBox(
//                  width: MediaQuery.of(context).size.width * 0.1,
//                ),
//                Center(
//                  child: Icon(
//                    Icons.attach_money,
//                    color: ScreenUtileColors.mainBlue,
//                  ),
//                ),
//                SizedBox(
//                  width: 10.0,
//                ),
//                DropdownButtonHideUnderline(
//                  child:  DropdownButton<String>(
//                    //isDense: true,
//                    items: unitData.map((map) => DropdownMenuItem<String>(
//                      child: Text('${map.unite_price} - ${map.unite_value}'),
//                      value: '${map.unite_price} - ${map.unite_value}',
//                    ))
//                        .toList(),
//                    onChanged: (value) {
//                      setState(() {
//                        selectedUnit = value;
//                        isValueOfUnitSelected = true ;
//                      });
//                    },
//                    isExpanded: false,
//                    //value: _currentUser,
//                    hint:(isValueOfUnitSelected == false) ? Text ('إختيار المبلغ') : Text(selectedUnit),
//                  ),
//                ),
//                SizedBox(
//                  width: MediaQuery.of(context).size.width * 0.2,
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _drawBtnSend(){
//    return Center(
//      child: Container(
//        height: 40.0,
//        width: 200,
//        child: RaisedButton(
//          color: ScreenUtileColors.mainBlue,
//          onPressed: () async{
//            _phoneNumberUnitsString = _phoneNumberUnitsController.text.toString();
//            SharedPreferences prefs = await SharedPreferences.getInstance();
//            String sessionId = prefs.get('hasSessionId');
//
//            if(_formKey.currentState.validate()){
//              _userName               =    _userNameController.text.toString() ;
//              _address                =     _addressController.text.toString() ;
//              _carType                =      _carTypeController.text.toString() ;
//              _addressCar             =   _addressCarController.text.toString() ;
//
//              List<Map <String,String >> det =[
//                {
//                  "heading":"المعلومات الشخصية"
//                },
//                {
//                  "user_name":_userName
//                },
//                {
//                  "address":_address
//                },
//                {
//                  "new_line":"new_line"
//                },
//                {
//                  "heading":"تفاصيل السيارة"
//                },
//                {
//                  "car_type":_carType
//                },
//                {
//                  "car_address":_addressCar
//                },
//                {
//                  "new_line":"new_line"
//                },
//                {
//                  "heading":"تحويل وحدات"
//                },
//                {
//                  "phone_Number_Units":_phoneNumberUnitsString
//                },
//                {
//                  "unit_value": selectedUnit
//                },
//
//              ];
//              var response = await helpersApi.addNewOrderDio(
//                  sessionId, "Wheel", det, null);
//
//              if (response.errors_code.length > 0) {
//                Fluttertoast.showToast(msg: response.result);
//              } else {
//                // Fluttertoast.showToast(msg: response.result);
//                PublicMethods.showCustomDialog(context, response.result);
//              }
//            }
//
//          },
//          child: Center(
//            child: Text(
//              'إرسال الآن',
//              style: TextStyle(
//                color: Colors.white,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}