import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/service_model/final_page_model.dart';
import 'package:delevery_online/Model/unit_model.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/other/final_page_bloc.dart';
import 'package:delevery_online/other/unit_bloc.dart';
import 'package:delevery_online/public_methods.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalPageScreen extends StatefulWidget {
  String serviceIdComing;
  String serviceNameComing;
  bool isHasUnitInFinalPage;
  List<Map<String, dynamic>> productsQuantity;
  String serviceCover;

  FinalPageScreen(
      {this.serviceIdComing,
      this.serviceNameComing,
      this.isHasUnitInFinalPage,
      this.productsQuantity,
      this.serviceCover});

  @override
  _FinalPageScreenState createState() => _FinalPageScreenState();
}

class _FinalPageScreenState extends State<FinalPageScreen> {
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  var helpersApi = new HelpersApi();
  final _formKey = GlobalKey<FormState>();
  String selectedUnit = "";
  bool isValueOfUnitSelected = false;
  TextEditingController _phoneNumberUnitsController;
  List<Map<String, dynamic>> productDetails = [];
  var imagesUrl = ApiUtil.imagesUrl;
  FinalPageBloc finalPageBloc;
  UnitBloc unitBloc;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();


  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2040));

  Future<TimeOfDay> _selectTime(BuildContext context) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
      );

  Future<Null> checkInternetConnection() async {
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          } else {
            showDialogNoInternet(); // show dialog
          }
        }).catchError((error) {
          showDialogNoInternet(); // show dialog
        });
      } on SocketException catch (_) {
        showDialogNoInternet();// show dialog
      }
    });
  }

  void showDialogNoInternet() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("غير متصل بالانترنت"),
        content: Text("الرجاء التأكد من الاتصال بالانترنت"),
        actions: <Widget>[
          FlatButton(
              child: Text("إعادة المحاولة"),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => FinalPageScreen(
                              serviceIdComing: widget.serviceIdComing,
                              serviceCover: widget.serviceCover,
                              serviceNameComing: widget.serviceNameComing,
                              isHasUnitInFinalPage: widget.isHasUnitInFinalPage,
                              productsQuantity: widget.productsQuantity,
                            )));
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    finalPageBloc = new FinalPageBloc();
    unitBloc = new UnitBloc();
    _phoneNumberUnitsController = new TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberUnitsController.dispose();
    finalPageBloc.dispose();
    unitBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = new ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
    var textFields = <Widget>[];
    List<Map<String, dynamic>> test = [];
    String _timeSelected;
    String _dateSelected;
    Widget _drawUnit(List<UnitModel> unitModelStream) {
      return Padding(
        padding:
            EdgeInsets.only(top: 4.0, left: 20.0, right: 20.0, bottom: 8.0),
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
                    child: DropdownButton<String>(
                      //isDense: true,
                      items: unitModelStream
                          .map((map) => DropdownMenuItem<String>(
                                child: Text(
                                    '${map.unite_price} - ${map.unite_value}'),
                                value:
                                    '${map.unite_price} - ${map.unite_value}',
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
                      hint: (isValueOfUnitSelected == false)
                          ? Text('إختيار المبلغ')
                          : Text(selectedUnit),
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
    Widget _drawScreen(BuildContext context, List<FinalPageModel> _finalPageModel) {
      // add Cover
      if (widget.serviceCover != '') {
        textFields.add(
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: CachedNetworkImage(
              imageUrl: "$imagesUrl${widget.serviceCover}",
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
          ),
        );
      }
      if (widget.productsQuantity != null) {
        test.add({
          "details": widget.productsQuantity,
        });
      }
      for (int i = 0; i < _finalPageModel.length; i++) {
        // Draw Text Form Field
        if (_finalPageModel[i].input_type == 'Text') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 6.0, bottom: 12),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Flexible(
                      child: Center(
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: _finalPageModel[i].textEditingController,
                          keyboardType: (_finalPageModel[i].is_phone == true)
                              ? TextInputType.phone
                              : TextInputType.text,
                          validator: (value) {
                            if (_finalPageModel[i].is_required == true) {
                              if (value.isEmpty || value.trim().isEmpty) {
                                return "الرجاء تعبئة هذا الحقل";
                              }
                              return null;
                            }
                            return value;
                          },
                          decoration: InputDecoration(
                            labelText: _finalPageModel[i].hint,
                            hintText: _finalPageModel[i].placeholder,
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
            ),
          );
//          if (_finalPageModel[i].textEditingController.text.toString().isNotEmpty){
//            test.add({
//              "heading": "المعلومات الشخصية",
//            });
//            test.add({
//              "F${_finalPageModel[i].id}":
//              _finalPageModel[i].textEditingController.text.toString(),
//            });
//            test.add({"new_line": "new_line"});
//          }
        }
        // Draw Radio
        if (_finalPageModel[i].input_type == 'Radio') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    Column(
                      children: <Widget>[
                        Visibility(
                          child: Text(
                            _finalPageModel[i].hint,
                            style: TextStyle(
                                color: ScreenUtileColors.mainBlue,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 30,
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: (_finalPageModel[i].option_1 == '')
                                      ? false
                                      : true,
                                  child: Radio(
                                    value: _finalPageModel[i].option_1,
                                    groupValue: _finalPageModel[i].testText,
                                    onChanged: (String val) {
                                      setState(() {
                                        _finalPageModel[i].testText = val;
                                      });
                                    },
                                    activeColor: ScreenUtileColors.mainBlue,
                                  ),
                                ),
                                Flexible(
                                  child: Visibility(
                                    visible: (_finalPageModel[i].option_1 == '')
                                        ? false
                                        : true,
                                    child: Text(
                                      _finalPageModel[i].option_1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: (_finalPageModel[i].option_2 == '')
                                      ? false
                                      : true,
                                  child: Radio(
                                    value: _finalPageModel[i].option_2,
                                    groupValue: _finalPageModel[i].testText,
                                    onChanged: (String val) {
                                      setState(() {
                                        _finalPageModel[i].testText = val;
                                      });
                                    },
                                    activeColor: ScreenUtileColors.mainBlue,
                                  ),
                                ),
                                Flexible(
                                  child: Visibility(
                                    visible: (_finalPageModel[i].option_2 == '')
                                        ? false
                                        : true,
                                    child: Text(
                                      _finalPageModel[i].option_2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                  visible: (_finalPageModel[i].option_3 == '')
                                      ? false
                                      : true,
                                  child: Radio(
                                    value: _finalPageModel[i].option_3,
                                    groupValue: _finalPageModel[i].testText,
                                    onChanged: (String val) {
                                      setState(() {
                                        _finalPageModel[i].testText = val;
                                      });
                                    },
                                    activeColor: ScreenUtileColors.mainBlue,
                                  ),
                                ),
                                Flexible(
                                  child: Visibility(
                                    visible: (_finalPageModel[i].option_3 == '')
                                        ? false
                                        : true,
                                    child: Text(
                                      _finalPageModel[i].option_3,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
//          if (_finalPageModel[i].testText.toString().isNotEmpty) {
//            test.add({
//              "heading": "معلومات الحجز",
//            });
//            test.add({
//              "F${_finalPageModel[i].id}": _finalPageModel[i].testText,
//            });
//          }
        }
        // Draw Date
        if (_finalPageModel[i].input_type == 'Date') {
          textFields.add(
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, top: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${_finalPageModel[i].hint}'),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            color: ScreenUtileColors.mainBlue,
                            child: Text(
                              "تحديد",
                              style:
                                  TextStyle(color: ScreenUtileColors.fontColor),
                            ),
                            onPressed: () async {
                              final selectedDate = await _selectDate(context);
                              if (selectedDate == null) return;
                              setState(() {
                                this._date = DateTime(selectedDate.year,
                                    selectedDate.month, selectedDate.day);
                              });
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: (_date == DateTime.now())
                                ? Text("")
                                : Text(
                                    "التاريخ ${_date.toString().substring(0, 10)}")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
//          if (_finalPageModel[i].is_required == true) {
//            _dateSelected = _date.toString().substring(0, 10);
//            test.add({
//              "heading": "معلومات الحجز",
//            });
//            test.add({
//              "F${_finalPageModel[i].id}": _dateSelected,
//            });
//          }
        }
        // Draw Time
        if (_finalPageModel[i].input_type == 'Time') {
          textFields.add(
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, top: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_finalPageModel[i].hint),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            color: ScreenUtileColors.mainBlue,
                            child: Text(
                              "تحديد",
                              style:
                                  TextStyle(color: ScreenUtileColors.fontColor),
                            ),
                            onPressed: () async {
                              final selectedTime = await _selectTime(context);
                              if (selectedTime == null) return;
                              setState(() {
                                this._time = TimeOfDay(
                                  hour: selectedTime.hour,
                                  minute: selectedTime.minute,
                                );
                              });
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: (_time == TimeOfDay.now())
                              ? Text("")
                              : Text(
                                  " الوقت ${_time.toString().substring(10, 15)}"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
//          if (_time != TimeOfDay.now() &&
//              _finalPageModel[i].is_required == true) {
//            _timeSelected = _time.toString().substring(10, 15);
//            test.add({
//              "heading": "معلومات الحجز",
//            });
//            test.add({
//              "F${_finalPageModel[i].id}": _timeSelected,
//            });
//            test.add({"new_line": "new_line"});
//          }
        }
        // Draw Text Area
        if (_finalPageModel[i].input_type == 'Textarea') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                child: TextFormField(
                  controller:
                      _finalPageModel[i].textEditingControllerForTextArea,
                  validator: (value) {
                    if (_finalPageModel[i].is_required == true) {
                      if (value.isEmpty ||  value.trim().isEmpty) {
                        return "الرجاء تعبئة هذا الحقل";
                      }
                      return null;
                    }
                    return value;
                  },
                  autofocus: false,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: _finalPageModel[i].hint,
                      hintText: _finalPageModel[i].placeholder,
                      border: InputBorder.none),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
          );
//          if (_finalPageModel[i].textEditingControllerForTextArea.text.toString().isNotEmpty){
//            test.add({
//              "heading": "معلومات أخرى",
//            });
//            test.add({
//              "F${_finalPageModel[i].id}": _finalPageModel[i]
//                  .textEditingControllerForTextArea
//                  .text
//                  .toString(),
//            });
//            test.add({"new_line": "new_line"});
//          }
        }
      }

      // draw Unite
        if (widget.isHasUnitInFinalPage == true) {
        // getListOfUnit();
        textFields.add(new StreamBuilder(
          stream: unitBloc.unitStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<UnitModel>> snapshotUnit) {
            switch (snapshotUnit.connectionState) {
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
        ));

      }





      // draw btn
      textFields.add(Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: RaisedButton(
          color: ScreenUtileColors.mainBlue,
          child: Text(
            "إطلب الآن",
            style: TextStyle(color: ScreenUtileColors.fontColor),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.getString('hasSessionId');
            if (_formKey.currentState.validate()) {
              PublicMethods.startConnectionDialog(context, 'الرجاء الانتظار');
              for (int i = 0; i < _finalPageModel.length; i++) {
                // Draw Text Form Field
                if (_finalPageModel[i].input_type == 'Text') {
                  if (_finalPageModel[i].textEditingController.text.toString().isNotEmpty){
                    test.add({
                      "heading": "المعلومات الشخصية",
                    });
                    test.add({
                      "F${_finalPageModel[i].id}":
                      _finalPageModel[i].textEditingController.text.toString(),
                    });
                    test.add({"new_line": "new_line"});
                  }
                }
                // Draw Radio
                if (_finalPageModel[i].input_type == 'Radio') {

                  if (_finalPageModel[i].testText.toString().isNotEmpty) {
                    test.add({
                      "heading": "معلومات الحجز",
                    });
                    test.add({
                      "F${_finalPageModel[i].id}": _finalPageModel[i].testText,
                    });
                  }
                }
                // Draw Date
                if (_finalPageModel[i].input_type == 'Date') {
                  if (_finalPageModel[i].is_required == true) {
                    _dateSelected = _date.toString().substring(0, 10);
                    test.add({
                      "heading": "معلومات الحجز",
                    });
                    test.add({
                      "F${_finalPageModel[i].id}": _dateSelected,
                    });
                  }
                }
                // Draw Time
                if (_finalPageModel[i].input_type == 'Time') {
                  if (_time != TimeOfDay.now() &&
                      _finalPageModel[i].is_required == true) {
                    _timeSelected = _time.toString().substring(10, 15);
                    test.add({
                      "heading": "معلومات الحجز",
                    });
                    test.add({
                      "F${_finalPageModel[i].id}": _timeSelected,
                    });
                    test.add({"new_line": "new_line"});
                  }
                }
                // Draw Text Area
                if (_finalPageModel[i].input_type == 'Textarea') {
                  if (_finalPageModel[i].textEditingControllerForTextArea.text.toString().isNotEmpty){
                    test.add({
                      "heading": "معلومات أخرى",
                    });
                    test.add({
                      "F${_finalPageModel[i].id}": _finalPageModel[i]
                          .textEditingControllerForTextArea
                          .text
                          .toString(),
                    });
                    test.add({"new_line": "new_line"});
                  }
                }
              }
              if (_phoneNumberUnitsController.text.toString().isNotEmpty) {
                test.add(
                  {"heading": "تحويل وحدات"},
                );
                test.add(
                  {
                    "phone_Number_Units": _phoneNumberUnitsController.text.toString(),
                  },
                );
                test.add(
                  {"unit_value": selectedUnit},
                );
                test.add(
                  {"new_line": "new_line"},
                );
              }
              var response = await helpersApi.addNewOrderDio(
                  sessionId, widget.serviceNameComing, test, null);
              if (response.errors_code.length > 0) {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: response.result);
              } else {
                Navigator.pop(context);
                PublicMethods.showCustomDialog(context, response.result);
              }
            }
          },
        ),
      ));

      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color : Colors.white,
          child: Stack(children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: textFields,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceNameComing),
      ),
      body: StreamBuilder(
        stream: finalPageBloc.finalPageStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<FinalPageModel>> snapShotFinalPage) {
          switch (snapShotFinalPage.connectionState) {
            case ConnectionState.none:
              error("no thing Work");
              break;
            case ConnectionState.waiting:
              finalPageBloc.fetchFinalPage.add("${widget.serviceIdComing}");
              return loading();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              textFields = [];
              return _drawScreen(context, snapShotFinalPage.data);
              // return _drawScreen(context, snapShotFinalPage.data);
              break;
          }
          return Container();
        },
      ),
    );
  }
}
