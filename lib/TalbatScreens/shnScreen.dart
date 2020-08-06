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
//class ChargeScreen extends StatefulWidget {
//  @override
//  _ChargeScreenState createState() => _ChargeScreenState();
//}
//
//class _ChargeScreenState extends State<ChargeScreen> {
//  ScreenConfig screenConfig;
//  WidgetSize widgetSize;
//  String radioValue;
//
//  TextEditingController _senderNameController;
//  TextEditingController _addressOfSenderController;
//  TextEditingController _phoneNumberSenderController;
//  TextEditingController _receiveNameController; //todo
//  TextEditingController _addressOfReceiveController;
//  TextEditingController _phoneNumberReceiveController;
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
//  String _senderName;
//  String _addressOfSender;
//  String _phoneNumberSender;
//  String _receiveName;
//  String _addressOfReceive;
//  String _phoneNumberReceive;
//  String _phoneNumberUnitsString;
//  final _formKey = GlobalKey<FormState>();
//
//  @override
//  void initState() {
//    _senderNameController = TextEditingController();
//    _addressOfSenderController = TextEditingController();
//    _phoneNumberSenderController = TextEditingController();
//    _receiveNameController = TextEditingController();
//    _addressOfReceiveController = TextEditingController();
//    _phoneNumberReceiveController = TextEditingController();
//    _phoneNumberUnitsController = TextEditingController();
//    getListOfUnit();
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _senderNameController.dispose();
//    _addressOfSenderController.dispose();
//    _phoneNumberSenderController.dispose();
//    _receiveNameController.dispose();
//    _addressOfReceiveController.dispose();
//    _phoneNumberReceiveController.dispose();
//    _phoneNumberUnitsController.dispose();
//    super.dispose();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    screenConfig = ScreenConfig(context);
//    widgetSize = WidgetSize(screenConfig);
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("شحن",),
//      ),
//        //resizeToAvoidBottomPadding: false,
//        body: new Container(
//      height: MediaQuery.of(context).size.height,
//      color: Colors.white12,
//      child: SingleChildScrollView(
//        child: new Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            _drawHeader(),
//            _drawForm(),
//            _drawUnits(),
//            SizedBox(
//              height: 30.0,
//            ),
//            _drawBtnSend(),
//            SizedBox(
//              height: 15.0,
//            ),
//            SizedBox(
//              height: MediaQuery.of(context).size.height * 0.01,
//            )
//          ],
//        ),
//      ),
//    ));
//  }
//
//  Widget _drawHeader() {
//    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//            image: AssetImage("assests/images/Charge.jpg"), fit: BoxFit.cover),
//      ),
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height * 0.30,
//    );
//  }
//
//  Widget _drawForm() {
//    return Padding(
//      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//      child: Form(
//        key: _formKey,
//        child: new Column(
//          textDirection: TextDirection.rtl,
//          children: <Widget>[
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.person,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        controller: _senderNameController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال الاسم الثلاثي';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'الاسم الثلاثي',
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                          labelStyle: TextStyle(
//                              fontSize: widgetSize.titleFontSize,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 15.0,
//            ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.place,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        controller: _addressOfSenderController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال عنوان المرسل';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'عنوان المرسل',
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                          labelStyle: TextStyle(
//                              fontSize: widgetSize.titleFontSize,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 15.0,
//            ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.phone,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        keyboardType: TextInputType.phone,
//                        controller: _phoneNumberSenderController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال رقم موبايل المرسل';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'رقم موبايل المرسل',
//                          labelStyle: TextStyle(
//                              fontWeight: FontWeight.bold, color: Colors.grey),
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 15.0,
//            ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.person,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        controller: _receiveNameController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال اسم المرسل إليه';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'اسم المرسل إليه (الثلاثي)',
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                          labelStyle: TextStyle(
//                              fontSize: widgetSize.titleFontSize,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 30.0,
//            ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.place,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        controller: _addressOfReceiveController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال عنوان المرسل إليه';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'عنوان المرسل إليه',
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                          labelStyle: TextStyle(
//                              fontSize: widgetSize.titleFontSize,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 30.0,
//            ),
//            Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.1,
//                  ),
//                  Center(
//                    child: Icon(
//                      Icons.phone,
//                      color: ScreenUtileColors.mainBlue,
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
//                  Flexible(
//                    child: Center(
//                      child: TextFormField(
//                        keyboardType: TextInputType.phone,
//                        controller: _phoneNumberReceiveController,
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'الرجاء إدخال رقم المرسل إليه';
//                          }
//                          return null;
//                        },
//                        textDirection: TextDirection.rtl,
//                        decoration: InputDecoration(
//                          labelText: 'رقم المرسل إليه',
//                          focusedBorder: UnderlineInputBorder(
//                            borderRadius: BorderRadius.horizontal(
//                              left: Radius.zero,
//                              right: Radius.zero,
//                            ),
//                            borderSide: BorderSide(
//                                color: ScreenUtileColors.mainBlue,
//                                width: 0.5,
//                                style: BorderStyle.solid),
//                          ),
//                          labelStyle: TextStyle(
//                              fontSize: widgetSize.titleFontSize,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                        ),
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                  ),
//                ],
//              ),
//            ),
//          ],
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
//  Widget _drawBtnSend() {
//    return Center(
//      child: Container(
//        height: 40.0,
//        width: 200,
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(20),
//        ),
//        child: RaisedButton(
//          color: ScreenUtileColors.mainBlue,
//          onPressed: () async {
//            _phoneNumberUnitsString = _phoneNumberUnitsController.text.toString();
//            if (_formKey.currentState.validate()) {
//              SharedPreferences prefs = await SharedPreferences.getInstance();
//              String sessionId = prefs.get('hasSessionId');
//              _senderName             = _senderNameController.text.toString();
//              _addressOfSender        = _addressOfSenderController.text.toString();
//              _phoneNumberSender      = _phoneNumberSenderController.text.toString();
//              _receiveName            = _receiveNameController.text.toString();
//              _addressOfReceive       = _addressOfReceiveController.text.toString();
//              _phoneNumberReceive     = _phoneNumberReceiveController.text.toString();
//              List<Map <String,String >> det =[
//                {
//                  "heading":"معلومات المرسل  "
//                },
//                {
//                  "sender_name":_senderName
//                },
//                {
//                  "address_of_sender":_addressOfSender
//                },
//                {
//                  "phone_number_sender":_phoneNumberSender
//                },
//                {
//                  "new_line":"new_line"
//                },
//                {
//                  "heading":"معلومات المرسل إليه  "
//                },
//                {
//                  "receive_name":_receiveName
//                },
//                {
//                  "address_of_receive":_addressOfReceive
//                },
//                {
//                  "phone_number_receive":_phoneNumberReceive
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
//                {
//                  "new_line":"new_line"
//                }
//              ];
//              var response = await helpersApi.addNewOrderDio(
//                  sessionId, "Charge", det, null);
//
//              if (response.errors_code.length > 0) {
//                Fluttertoast.showToast(msg: response.result);
//              } else {
//                // Fluttertoast.showToast(msg: response.result);
//                PublicMethods.showCustomDialog(context, response.result);
//              }
//              // TODO : Call Api for send Shn Data
//              //   var response = await helpersApi.sendShnData(
//              //       senderName, addressOfSender,phoneNumberSender
//              //       ,receiveName,addressOfReceive,phoneNumberReceive);
//              //
//              //   if (response) {
//              //     Navigator.push(context,
//              //         MaterialPageRoute(builder: (context) {
//              //           return HomeScreen();
//              //         }));
//              //   } else {
//              //     loginError = true;
//              //   }
//            }
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
//
