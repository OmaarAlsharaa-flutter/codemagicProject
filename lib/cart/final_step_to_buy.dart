import 'package:delevery_online/Model/add_order_model.dart';
import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/other/unit_bloc.dart';
import 'package:delevery_online/public_methods.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FinalStepToBuy extends StatefulWidget {
  @override
  _FinalStepToBuyState createState() => _FinalStepToBuyState();
}

class _FinalStepToBuyState extends State<FinalStepToBuy> {
  var helpersApi = new HelpersApi();
  TextEditingController     _userNameController ;
  TextEditingController     _addressController ;
  TextEditingController     _phoneNumberController ;
  TextEditingController     _phoneNumberUnitsController ;
  String    _userName   ;
  String    _address   ;
  String    _phoneNumber;
  String    _phoneNumberUnitsString;
  String    selectedUnit = "إختر المبلغ" ;
  bool      isValueOfUnitSelected = false ;
  UnitBloc unitBloc;
  AddOrderModel response;
  final _formKey = GlobalKey<FormState>();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  String radioValue;



  @override
  void initState() {
    super.initState();
    unitBloc = new UnitBloc();
    _userNameController         = new TextEditingController();
    _addressController          = new TextEditingController();
    _phoneNumberController      = new TextEditingController();
    _phoneNumberUnitsController = new TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _phoneNumberUnitsController.dispose();
    unitBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
        body: new Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white12,
          child: SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _drawHeader(),
                _drawForm(),
                _drawUnits(),
                SizedBox(
                  height: 30.0,
                ),
                _drawBtnSend(context),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                )
              ],
            ),
          ),
        )
    );
  }

  Widget _drawHeader(){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
          Text("الخطوة الأخيرة",
            style: TextStyle(color: ScreenUtileColors.mainBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Divider(
            height: 2,
            color: ScreenUtileColors.mainBlue,
          ),

          SizedBox(
            height: 10.0,
          ),
        ],

      ),
    );
  }

  Widget _drawForm(){
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Form(
        key: _formKey,
        //  padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: new Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
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
                        validator: (value) {
                          if (value.isEmpty || value.trim().isEmpty) {
                            return 'الرجاء إدخال الاسم الثلاثي';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
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
                        validator: (value) {
                          if (value.isEmpty || value.trim().isEmpty) {
                            return 'الرجاء إدخال العنوان بالتفصيل';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'العنوان',
                          hintText: 'الحي - الشارع - البناء',
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
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty || value.trim().isEmpty) {
                            return 'الرجاء إدخال رقم الموبايل';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'رقم الموبايل',
                          hintText: '09XXXXXXXX',
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
          ],
        ),
      ),
    );
  }
  Widget _drawUnits() {
    return StreamBuilder(
      stream: unitBloc.unitStream,
      builder: (BuildContext context , AsyncSnapshot <List<UnitModel>> snapshotUnit){
        switch(snapshotUnit.connectionState){
          case ConnectionState.none:
            error("no units");
            break;
          case ConnectionState.waiting:
            unitBloc.fetchUnits.add('0');
            loading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return _drawUnit(snapshotUnit.data);
            break;

        }
        return Container();
      },

    );

  }
  Widget _drawUnit(List<UnitModel> unitModelStream){
    return Padding(
      padding: EdgeInsets.only(
          top: 4.0, left: 20.0, right: 20.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Text(
            PublicMethods.unit,
            style:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1,
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberUnitsController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'رقم موبايل ',
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.1,
                ),
                Center(
                  child: Icon(
                    Icons.attach_money,
                    color: ScreenUtileColors.mainBlue,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    //isDense: true,
                    items: unitModelStream.map((map) =>
                        DropdownMenuItem<String>(
                          child: Text(
                              '${map.unite_price} - ${map.unite_value}'),
                          value: '${map.unite_price} - ${map
                              .unite_value}',
                        ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value;
                        isValueOfUnitSelected = true;
                      });
                    },
                    isExpanded: false,
                    //value: _currentUser,
                    hint: (isValueOfUnitSelected == false) ? Text(
                        'إختيار المبلغ') : Text(selectedUnit),
                  ),
                ),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _drawBtnSend(BuildContext context) {
    return Center(
      child: Container(
        height: 40.0,
        width: 200,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 4.0,
          child: RaisedButton(
            color: ScreenUtileColors.mainBlue,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String sessionId = prefs.get('hasSessionId');
              _phoneNumberUnitsString = _phoneNumberUnitsController.text.toString();
              if (_formKey.currentState.validate()) {
                PublicMethods.startConnectionDialog(context, 'الرجاء الانتظار');
                _userName = _userNameController.text.toString();
                _address = _addressController.text.toString();
                _phoneNumber = _phoneNumberController.text.toString();

                List<Map<String, String>> det = [
                  {
                    "heading":"المعلومات الشخصية"
                  },
                  {
                    "user_name":_userName
                  },
                  {
                    "address":_address
                  },
                  {
                    "phone_Number":_phoneNumber
                  },
                  {
                    "new_line":"new_line"
                  },
                  {
                    "heading":"تحويل وحدات"
                  },
                  {"phone_Number_Units": _phoneNumberUnitsString},
                  {"unit_value": selectedUnit},
                  {"new_line": "new_line"},
                ];
                response = await helpersApi.addNewOrderDio(
                    sessionId, "Cart", det, null);

                if (response.errors_code.length > 0) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: response.result);
                } else {
                  await helpersApi.fetchSessionId().then((data){
                  Navigator.pop(context);
                  PublicMethods.showCustomDialog(context, response.result);
                });
                }
              }
            },
            child: Center(
              child: Text(
                'إرسال الآن',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setRadioValue(String val) {
    setState(() {
      radioValue = val;
    });
  }
}
