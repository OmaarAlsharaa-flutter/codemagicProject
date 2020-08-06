import 'dart:io';
import 'package:delevery_online/Model/add_order_model.dart';
import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/other/unit_bloc.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public_methods.dart';

class OnPagingFoater extends StatefulWidget {
  @override
  _OnPagingFoaterState createState() => _OnPagingFoaterState();
}

class _OnPagingFoaterState extends State<OnPagingFoater> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _paymentWithOutPhotoController;
  String _paymentWithOutPhotoControllerString;
  HelpersApi helpersApi = new HelpersApi();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  File _image;


  @override
  void initState() {
    super.initState();
    _paymentWithOutPhotoController = new TextEditingController();
  }

  @override
  void dispose() {
    _paymentWithOutPhotoController.dispose();
    super.dispose();
  }

  getImageFileWithOutCrop(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source,imageQuality: 90);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);

    return _firstPage();
  }
  Widget _firstPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "دفع فواتير",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
          )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _drawHeader(),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  "قم بتصوير فاتورة سابقة عبر الضغط على زر الكاميرا أو اختيارها من الاستديو",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                  width: 250,
                  height: 180,
                  child: Center(
                      child: _image != null
                          ? Image.file(_image)
                          : Image(
                              image: AssetImage("assests/images/imgbroken.png"),
                            ))),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    color: ScreenUtileColors.mainBlue,
                    onPressed: () {
                      getImageFileWithOutCrop(ImageSource.camera);
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: ScreenUtileColors.fontColor,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  new RaisedButton(
                    color: ScreenUtileColors.mainBlue,
                    onPressed: () {
                      getImageFileWithOutCrop(ImageSource.gallery);
                    },
                    child: Icon(
                      Icons.image,
                      color: ScreenUtileColors.fontColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  "ملاحظة: \n إذا لم يكن لديك فاتورة سابقة ضع المعلومات الكاملة عن الفاتورة التي تريد دفعها أو ورقة رسمية لا تحتاج وجود صاحب العلاقة في المربع التالي",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                width:
                    (screenConfig.screenType == ScreenType.SMALL) ? 300 : 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextField(
                  controller: _paymentWithOutPhotoController,
                  decoration: InputDecoration(),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                    height: 40.0,
                    width: 150,
                    child: RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      onPressed: () {
                        if (_image == null &&
                            _paymentWithOutPhotoController.text
                                .toString()
                                .isEmpty) {
                          Fluttertoast.showToast(
                              msg:
                                  "الرجاء إدخال صورة الفاتورة أو معلومات عنها");
                        } else {
                          _paymentWithOutPhotoControllerString = _paymentWithOutPhotoController.text.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                maintainState: true,
                                  settings: RouteSettings(name: "SecondPage"),
                                  builder: (context) => SecondPage(_image ,_paymentWithOutPhotoControllerString  )
                              ));
                          Navigator.popUntil(
                              context, ModalRoute.withName("SecondPage"));
                        }
                      },
                      child: Center(
                        child: Text(
                          "التالي",
                          style: TextStyle(
                            color: ScreenUtileColors.fontColor,
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Widget _secondPage(BuildContext context , Widget _drawUnits(BuildContext context)) {
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("الرجاء إكمال المعلومات"),
//        centerTitle: true,
//      ),
//      body: Container(
//        height: MediaQuery.of(context).size.height,
//        color: Colors.white12,
//        child: SingleChildScrollView(
//          child: Form(
//            key: _formKey,
//            child: new Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                SizedBox(
//                  height: 40,
//                ),
//                Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.1,
//                      ),
//                      Center(
//                        child: Icon(
//                          Icons.person,
//                          color: ScreenUtileColors.mainBlue,
//                        ),
//                      ),
//                      SizedBox(
//                        width: 10.0,
//                      ),
//                      Flexible(
//                        child: Center(
//                          child: TextFormField(
//                            controller: _userNameController,
//                            textDirection: TextDirection.rtl,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'الرجاء إدخال الاسم الثلاثي';
//                              }
//                              return null;
//                            },
//                            decoration: InputDecoration(
//                              labelText: 'الاسم الثلاثي',
//                              focusedBorder: UnderlineInputBorder(
//                                borderRadius: BorderRadius.horizontal(
//                                  left: Radius.zero,
//                                  right: Radius.zero,
//                                ),
//                                borderSide: BorderSide(
//                                    color: ScreenUtileColors.mainBlue,
//                                    width: 0.5,
//                                    style: BorderStyle.solid),
//                              ),
//                              labelStyle: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.grey),
//                            ),
//                          ),
//                        ),
//                      ),
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.2,
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//                Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.1,
//                      ),
//                      Center(
//                        child: Icon(
//                          Icons.place,
//                          color: ScreenUtileColors.mainBlue,
//                        ),
//                      ),
//                      SizedBox(
//                        width: 10.0,
//                      ),
//                      Flexible(
//                        child: Center(
//                          child: TextFormField(
//                            controller: _addressController,
//                            textDirection: TextDirection.rtl,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'الحي - الشارع - البناء';
//                              }
//                              return null;
//                            },
//                            decoration: InputDecoration(
//                              labelText: 'الحي - الشارع - البناء',
//                              focusedBorder: UnderlineInputBorder(
//                                borderRadius: BorderRadius.horizontal(
//                                  left: Radius.zero,
//                                  right: Radius.zero,
//                                ),
//                                borderSide: BorderSide(
//                                    color: ScreenUtileColors.mainBlue,
//                                    width: 0.5,
//                                    style: BorderStyle.solid),
//                              ),
//                              labelStyle: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.grey),
//                            ),
//                          ),
//                        ),
//                      ),
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.2,
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//                Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.1,
//                      ),
//                      Center(
//                        child: Icon(
//                          Icons.phone,
//                          color: ScreenUtileColors.mainBlue,
//                        ),
//                      ),
//                      SizedBox(
//                        width: 10.0,
//                      ),
//                      Flexible(
//                        child: Center(
//                          child: TextFormField(
//                            controller: _phoneNumberController,
//                            textDirection: TextDirection.rtl,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'رقم الموبايل';
//                              }
//                              return null;
//                            },
//                            keyboardType: TextInputType.phone,
//                            decoration: InputDecoration(
//                              labelText: 'رقم الموبايل',
//                              labelStyle: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.grey),
//                              focusedBorder: UnderlineInputBorder(
//                                borderRadius: BorderRadius.horizontal(
//                                  left: Radius.zero,
//                                  right: Radius.zero,
//                                ),
//                                borderSide: BorderSide(
//                                    color: ScreenUtileColors.mainBlue,
//                                    width: 0.5,
//                                    style: BorderStyle.solid),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                      SizedBox(
//                        width: MediaQuery.of(context).size.width * 0.2,
//                      ),
//                    ],
//                  ),
//                ),
//                _drawUnits(context),
//                SizedBox(
//                  height: 30.0,
//                ),
//                Center(
//                  child: Container(
//                      height: 40.0,
//                      width: 150,
//                      child: RaisedButton(
//                        color: ScreenUtileColors.mainBlue,
//                        onPressed: () async {
//                          _paymentWithOutPhotoControllerString =
//                              _paymentWithOutPhotoController.text.toString();
//                          SharedPreferences prefs =
//                              await SharedPreferences.getInstance();
//                          String sessionId = prefs.get('hasSessionId');
//                          if (_formKey.currentState.validate()) {
//                            _userNameString =
//                                _userNameController.text.toString();
//                            _addressString = _addressController.text.toString();
//                            _phoneNumberString =
//                                _phoneNumberController.text.toString();
//                            _phoneNumberUnitsString =
//                                _phoneNumberUnitsController.text.toString();
//                            List<Map<String, String>> det = [
//                              {"heading": "المعلومات الشخصية"},
//                              {"user_name": _userNameString},
//                              {"address": _addressString},
//                              {"phone_Number": _phoneNumberString},
//                              {"new_line": "new_line"},
//                              {"heading": "تفاصيل الفاتورة"},
//                              {
//                                "payment_details":
//                                    _paymentWithOutPhotoControllerString
//                              },
//                              {"new_line": "new_line"},
//                              {"heading": "تحويل وحدات"},
//                              {"phone_Number_Units": _phoneNumberUnitsString},
//                              {"unit_value": selectedUnit}
//                            ];
//                            var response = await helpersApi.addNewOrderDio(
//                                sessionId, "Payment", det, _image);
//
//                            if (response.errors_code.length > 0) {
//                              Fluttertoast.showToast(msg: response.result);
//                            } else {
//                              // Fluttertoast.showToast(msg: response.result);
//                              PublicMethods.showCustomDialog(
//                                  context, response.result);
//                            }
//                          }
//
//                          //Navigator.push(context,MaterialPageRoute(builder: (context)=> _secondPage()));
//                        },
//                        child: Center(
//                          child: Text(
//                            "إرسال الطلب",
//                            style: TextStyle(
//                              color: ScreenUtileColors.fontColor,
//                            ),
//                          ),
//                        ),
//                      )),
//                ),
//                SizedBox(
//                  height: MediaQuery.of(context).size.width * 0.1,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }



  Widget _drawHeader() {
   return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assests/images/allInvoice.jpg'),
          fit: BoxFit.fill
        )
      ),
    );
//    return Container(
//      child: Image.network(
//        "${ApiUtil.imagesUrl}i.jpg",
//        fit: BoxFit.fill,
//        width: MediaQuery.of(context).size.width,
//        height:  MediaQuery.of(context).size.height *0.30,
//      ),
//
////      decoration: BoxDecoration(
////        image: DecorationImage(
////            image: NetworkImage("${ApiUtil.imagesUrl}p.jpg"),
////            fit: BoxFit.fitWidth
////        ),
////      ),
////      width: MediaQuery.of(context).size.width,
////      height:  MediaQuery.of(context).size.height *0.30,
//    );
  }
}

class SecondPage extends StatefulWidget {
  File _image;
  String invoiceDetails;

  SecondPage(this._image ,this.invoiceDetails);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController;
  String _userNameString;
  TextEditingController _addressController;
  String _addressString;
  TextEditingController _phoneNumberController;
  String _phoneNumberString;
  TextEditingController _phoneNumberUnitsController;
  String _phoneNumberUnitsString;
  HelpersApi helpersApi = new HelpersApi();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  String selectedUnit = "إختر المبلغ" ;
  bool isValueOfUnitSelected = false ;
  UnitBloc unitBloc;
  AddOrderModel response;

  @override
  void initState() {
    super.initState();
    unitBloc = new UnitBloc();
    _userNameController = new TextEditingController();
    _addressController = new TextEditingController();
    _phoneNumberController = new TextEditingController();
    _phoneNumberUnitsController = new TextEditingController();
  }

  @override
  void dispose() {
    unitBloc.dispose();
    _userNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _phoneNumberUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    Widget _drawUnits(BuildContext context) {

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
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
//                  child: DropdownButton<String>(
//                    //isDense: true,
//                    items: unitData
//                        .map((map) => DropdownMenuItem<String>(
//                      child: Text(
//                          '${map.unite_price} - ${map.unite_value}'),
//                      value: '${map.unite_price} - ${map.unite_value}',
//                    ))
//                        .toList(),
//                    onChanged: (value) {
//                      setState(() {
//                        selectedUnit = value;
//                        isValueOfUnitSelected = true;
//                      });
//                    },
//                    isExpanded: false,
//                    //value: _currentUser,
//                    hint: (isValueOfUnitSelected == false)
//                        ? Text('إختيار المبلغ')
//                        : Text(selectedUnit),
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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("الرجاء إكمال المعلومات"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white12,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
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
                              if (value.isEmpty || value.trim().isEmpty) {
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
                          child: TextFormField(
                            controller: _addressController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty || value.trim().isEmpty) {
                                return 'الحي - الشارع - البناء';
                              }
                              return null;
                            },
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
                                    style: BorderStyle.solid),
                              ),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              hintStyle: TextStyle(
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
                          child: TextFormField(
                            controller: _phoneNumberController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty || value.trim().isEmpty) {
                                return 'رقم الموبايل';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
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
                _drawUnits(context),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Container(
                      height: 40.0,
                      width: 150,
                      child: RaisedButton(
                        color: ScreenUtileColors.mainBlue,
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String sessionId = prefs.get('hasSessionId');
                          if (_formKey.currentState.validate()) {
                            PublicMethods.startConnectionDialog(context, 'الرجاء الانتظار');
                            _userNameString =
                                _userNameController.text.toString();
                            _addressString = _addressController.text.toString();
                            _phoneNumberString =
                                _phoneNumberController.text.toString();
                            _phoneNumberUnitsString =
                                _phoneNumberUnitsController.text.toString();
                            List<Map<String, String>> det = [
                              {"heading": "المعلومات الشخصية"},
                              {"user_name": _userNameString},
                              {"address": _addressString},
                              {"phone_Number": _phoneNumberString},
                              {"new_line": "new_line"},
                              {"heading": "تفاصيل الفاتورة"},
                              {
                                "payment_details":
                                widget.invoiceDetails
                              },
                              {"new_line": "new_line"},
                              {"heading": "تحويل وحدات"},
                              {"phone_Number_Units": _phoneNumberUnitsString},
                              {"unit_value": selectedUnit},
                            ];
                            response = await helpersApi.addNewOrderDio(
                                sessionId, "Payment", det, widget._image);

                            if (response.errors_code.length > 0) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: response.result);
                            } else {
                              Navigator.pop(context);
                              PublicMethods.showCustomDialog(context, response.result);
                            }
                          }

                          //Navigator.push(context,MaterialPageRoute(builder: (context)=> _secondPage()));
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
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

