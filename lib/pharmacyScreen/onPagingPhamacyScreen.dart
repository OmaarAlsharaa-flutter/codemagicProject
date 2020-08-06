import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/add_order_model.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public_methods.dart';


class OnPagingPharmacy extends StatefulWidget {
  @override
  _OnPagingPharmacyState createState() => _OnPagingPharmacyState();
}

class _OnPagingPharmacyState extends State<OnPagingPharmacy> {
  ScreenConfig screenConfig ;
  WidgetSize widgetSize;
  Image img;
  File _image;

  TextEditingController _userNameController ;
  String _userNameString;
  TextEditingController _addressController ;
  String _addressString;
  TextEditingController _phoneNumberController ;
  String _phoneNumberString;
  AddOrderModel response;
  HelpersApi helpersApi = new HelpersApi();
  final _formKey = GlobalKey<FormState>();
  getImageFileWithOutCrop(ImageSource source) async{
    var image = await ImagePicker.pickImage(source: source,imageQuality: 90);
    if (image == null) return;
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController();
    _addressController = new TextEditingController();
    _phoneNumberController = new TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("الصيدلية الإلكترونية",

          style: TextStyle(
              fontSize: 20,
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
                Text("خدمة توصيل الدواء مجانية",
                  style: TextStyle(color: Colors.red,
                      fontWeight: FontWeight.bold , fontSize: 30),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20 , left:  20),
                  child: Text("قم بتصوير وصفة الدواء أو علبة الدواء عبر الضغط على زر الكاميرا أو اختيارها من الاستديو",
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: 250,
                    height: 180,
                    child: Center(child: _image != null ? Image.file(_image) : Image(image: AssetImage("assests/images/imgbroken.png"),))
                ),

                SizedBox(
                  height: 15.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      onPressed: () async {
                        getImageFileWithOutCrop(ImageSource.camera);
                      },
                      child: Icon(Icons.camera_alt ,color: ScreenUtileColors.fontColor,),
                    ),
                    SizedBox(width: 40,),
                    new RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      onPressed: () async {
                        getImageFileWithOutCrop(ImageSource.gallery);
                      },
                      child: Icon(Icons.image , color: ScreenUtileColors.fontColor,),
                    )
                  ],
                ),

                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20 , left:  20),
                  child: Text("ملاحظة: \n في حال وجود أكثر من علبة دواء يرجى مراعاة وضعها جانب بعضها البعض وتصويرها معاً بصورة واحدة بحيث تكون أسماء الأدوية واضحة",
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: Container(
                    height: 40.0,
                    width: 150,
                    child: RaisedButton(
                      color: ScreenUtileColors.mainBlue,
                      onPressed: (){
                        if(_image == null){
                          Fluttertoast.showToast(msg: "الرجاء إدخال صورة وصفة الدواء  ");
                        }else{
                          Navigator.push(context,
                              MaterialPageRoute(
                                maintainState: true,
                                  settings: RouteSettings(name: 'Second'),
                                  builder: (context)=> _secondPage())
                          );
                          Navigator.popUntil(
                              context, ModalRoute.withName("Second"));
                        }
                      },
                      child: Center(
                        child:  Text("التالي",
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
          child: Form(
            key: _formKey,
            child: Column(
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
                          child: TextFormField(
                            controller: _userNameController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value.isEmpty || value.trim().isEmpty) {
                                return 'الاسم الثلاثي';
                              }
                              return null;
                            },
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
                                    style: BorderStyle.solid
                                ),
                              ),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              hintStyle : TextStyle(
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
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty || value.trim().isEmpty) {
                                return 'رقم الموبايل';
                              }
                              return null;
                            },
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
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Container(
                      height: 40.0,
                      width: 150,
                      child: RaisedButton(
                        color: ScreenUtileColors.mainBlue,
                        onPressed: ()async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String sessionId = prefs.get('hasSessionId');
                          if(_formKey.currentState.validate()){
                            PublicMethods.startConnectionDialog(context, 'الرجاء الانتظار');
                            _userNameString = _userNameController.text.toString();
                            _addressString = _addressController.text.toString();
                            _phoneNumberString = _phoneNumberController.text.toString();
                            List<Map <String,String >> det =[
                              {
                                "heading":"المعلومات الشخصية"
                              },
                              {
                                "user_name":_userNameString

                              },
                              {
                                "address":_addressString
                              },
                              {
                                "phone_Number":_phoneNumberString
                              },
                            ];
                            response = await helpersApi.addNewOrderDio(
                                sessionId, "Pharmacy", det, _image);

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
      ),
    );
  }

  Widget _drawHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      child: CachedNetworkImage(
        imageUrl: "${ApiUtil.imagesUrl}p.jpg",
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


