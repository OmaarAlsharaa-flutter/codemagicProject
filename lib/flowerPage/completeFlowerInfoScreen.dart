import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public_methods.dart';


class CompleteFlowerInfoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> productsOnCart ;
  final List<Product> products;


  CompleteFlowerInfoScreen(this.productsOnCart, this.products);

  @override
  _CompleteFlowerInfoScreenState createState() => _CompleteFlowerInfoScreenState();
}

class _CompleteFlowerInfoScreenState extends State<CompleteFlowerInfoScreen> {
  TextEditingController     _userNameController ;
  TextEditingController     _addressController ;
  TextEditingController  _phoneNumberController ;
  TextEditingController _phoneNumberUnitsController ;

  String    _userName   ;
  String    _address   ;
  String    _phoneNumber;
  String _phoneNumberUnitsString;
  final _formKey = GlobalKey<FormState>();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  HelpersApi helpersApi = new HelpersApi();
  List<UnitModel> unitData = [];
  String selectedUnit = "" ;
  List<Map<String , dynamic>> flowerDetails = [] ;

  String _senderType ;
  setSenderType(String val) {
    setState(() {
      _senderType = val;
      print(_senderType);
    });
  }

  bool isValueOfUnitSelected = false ;
  void getListOfUnit() async {
    List data = await helpersApi.getUnitsData();
    print('unit data befor $unitData');
    for (int i = 0; i < data.length; i++) {
      setState(() {
        unitData.add(data[i]);
      });
    }
    print('unit data after ${unitData[0].unite_price}');
  }

  List<Map<String , dynamic>> getFlowerDetails (){
    for (int i = 0 ; i<widget.products.length ; i++){
      if(widget.productsOnCart[i]['quantity'] != 0){
        setState(() {
          flowerDetails.add({
            "flower_name" : widget.productsOnCart[i]['flower_name'],
            "price" : widget.productsOnCart[i]['price'],
            "quantity" : widget.productsOnCart[i]['quantity'],
            "break":"break",
          }
          );
        });
      }
    }
    print("Food Deatails $flowerDetails");
    return flowerDetails;
  }


@override
  void initState() {
    getFlowerDetails();
    _userNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _phoneNumberUnitsController = TextEditingController();
    getListOfUnit();
    super.initState();
  }
  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _phoneNumberUnitsController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
        appBar: AppBar(
          title: Text("الرجاء إكمال المعلومات"),
          centerTitle: true,
        ),
      //resizeToAvoidBottomPadding: false,
        body: new Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white12,
          child: SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _drawForm(),
                _drawUnits(),
                SizedBox(
                  height: 30.0,
                ),

                _drawBtnSend(),
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

  Widget _drawForm(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                          if (value.isEmpty) {
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
                          if (value.isEmpty) {
                            return 'الرجاء إدخال العنوان بالتفصيل';
                          }
                          return null;
                        },
                        textDirection: TextDirection.rtl,
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
                          if (value.isEmpty) {
                            return 'الرجاء إدخال رقم الموبايل';
                          }
                          return null;
                        },
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
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Text(
                    'أجور التحويل :',
                    style: TextStyle(
                        color: ScreenUtileColors.mainBlue,
                        fontWeight: FontWeight.normal),
                  ),
                  Radio(
                    value: 'المرسل',
                    groupValue: _senderType,
                    onChanged: (String val) {
                      setSenderType(val);

                    },
                    activeColor: ScreenUtileColors.mainBlue,
                  ),
                  Text(
                    'المرسل',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Radio(
                    value: 'المرسل إليه',
                    groupValue: _senderType,
                    onChanged: (String val) {
                      setSenderType(val);
                    },
                    activeColor: ScreenUtileColors.mainBlue,
                  ),
                  Text(
                    'المرسل إليه',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
  Widget _drawUnits(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            PublicMethods.unit,
            style:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberUnitsController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: 'رقم موبايل ',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
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
            height: 15.0,
          ),
          Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
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
                  child:  DropdownButton<String>(
                    //isDense: true,
                    items: unitData.map((map) => DropdownMenuItem<String>(
                      child: Text('${map.unite_price} - ${map.unite_value}'),
                      value: '${map.unite_price} - ${map.unite_value}',
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value;
                        isValueOfUnitSelected = true ;
                      });
                    },
                    isExpanded: false,
                    //value: _currentUser,
                    hint:(isValueOfUnitSelected == false) ? Text ('إختيار المبلغ') : Text(selectedUnit),
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
    );
  }

  Widget _drawBtnSend(){
    return Center(
      child: Container(
        height: 40.0,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: RaisedButton(
          color: ScreenUtileColors.mainBlue,
          onPressed : () async{
            _phoneNumberUnitsString = _phoneNumberUnitsController.text.toString();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.get('hasSessionId');
            if(_formKey.currentState.validate()){
              _userName =    _userNameController.text.toString() ;
              _address =    _addressController.text.toString() ;
              _phoneNumber= _phoneNumberController.text.toString() ;

              List<Map <String,dynamic >> det =[
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
                  "sender_type": _senderType
                },
                {
                  "new_line":"new_line"
                },
                {
                  "heading":"الطلبات "
                },
                {
                  "details" : flowerDetails
                },
                {
                  "new_line":"new_line"
                },
                {
                  "heading":"تحويل وحدات "
                },
                {
                  "phone_Number_Units":_phoneNumberUnitsString
                },
                {
                  "unit_value": selectedUnit
                },

              ];

              var response = await helpersApi.addNewOrderDio(
                  sessionId, "Flower", det, null);

              if (response.errors_code.length > 0) {
                Fluttertoast.showToast(msg: response.result);
              } else {
                // Fluttertoast.showToast(msg: response.result);
                PublicMethods.showCustomDialog(context, response.result);
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
    );
  }

}


