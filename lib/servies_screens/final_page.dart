import 'package:delevery_online/Model/service_model/final_page_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinalPage extends StatefulWidget {
  final String serviceIdComing;
  final String serviceNameComing;

  FinalPage(this.serviceIdComing, this.serviceNameComing , );

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  var helpersApi = new HelpersApi();
  final _formKey = GlobalKey<FormState>();
  List<FinalPageModel> _finalPageModel = [];
  List<String> test = [];
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2021));

  Future<TimeOfDay> _selectTime(BuildContext context) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
      );

//  void _delegateController() async {
//    List data = await helpersApi.printFinalPage(widget.serviceIdComing);
//    for (int i = 0; i < data.length; i++) {
//      setState(() {
//        _finalPageModel.add(data[i]);
//      });
//    }
//  }

  @override
  void initState() {
 //   _delegateController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.serviceIdComing);
    screenConfig = new ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);

    // This list of controllers can be used to set and get the text from/to the TextFields

    var textFields = <Widget>[];

      for (int i = 0; i < _finalPageModel.length; i++) {
        var textEditingControllers = <TextEditingController>[];
        var textEditingController = new TextEditingController();
        textEditingControllers.add(textEditingController);
        // Draw Text Form Field
        if (_finalPageModel[i].input_type == 'Text') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 6.0, bottom: 16),
              child: Container(
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
                          controller: textEditingController,
                          keyboardType: (_finalPageModel[i].is_phone == true)
                              ? TextInputType.phone
                              : TextInputType.text,
//                          onChanged: (value) {
//                            setState(() {
//                              this._finalPageModel[i].testText = value;
//                            });
//                          },
                          validator: (value) {
                            if (_finalPageModel[i].is_required == true) {
                              if (value.isEmpty) {
                                return "الرجاء تعبئة هذا الحقل";
                              }
                              return null;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: _finalPageModel[i].hint,
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
            ),
          );//  textFields.add(RaisedButton(onPressed: (){print(_finalPageModel[i].testText);},));
        }
        // Draw Radio
        if (_finalPageModel[i].input_type == 'Radio') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0,bottom: 12),
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
                                        print(_finalPageModel[i].testText);
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
                                        print(_finalPageModel[i].testText);
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
                                        print(_finalPageModel[i].testText);
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
        }
        // Draw Date
        if (_finalPageModel[i].input_type == 'Date') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        color: (_finalPageModel[i].is_required == true)
                            ? ScreenUtileColors.mainBlue
                            : Colors.grey,
                        child: Text(
                          _finalPageModel[i].hint,
                          style: TextStyle(color: ScreenUtileColors.fontColor),
                        ),
                        onPressed: (_finalPageModel[i].is_required == true)
                            ? () async {
                          final selectedDate = await _selectDate(context);
                          if (selectedDate == null) return;
                          print(selectedDate);
                          setState(() {
                            this._date = DateTime(selectedDate.year,
                                selectedDate.month, selectedDate.day);
                          });
                        }
                            : () {}),
                    SizedBox(width: 20,),
                    Flexible(
                        child: (_date == null)
                            ? Text("")
                            : Text(
                            "التاريخ ${_date.toString().substring(0, 10)}")),
                  ],
                ),
              ),
            ),
          );

        }
        // Draw Time
        if (_finalPageModel[i].input_type == 'Time') {
          textFields.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        color: (_finalPageModel[i].is_required == true)
                            ? ScreenUtileColors.mainBlue
                            : Colors.grey,
                        child: Text(
                          _finalPageModel[i].hint,
                          style: TextStyle(color: ScreenUtileColors.fontColor),
                        ),
                        onPressed: (_finalPageModel[i].is_required == true)
                            ? () async {
                          final selectedTime = await _selectTime(context);
                          if (selectedTime == null) return;
                          print(selectedTime);
                          setState(() {
                            this._time = TimeOfDay(
                              hour: selectedTime.hour,
                              minute: selectedTime.minute,
                            );
                          });
                        }
                            : () {}),
                    SizedBox(width: 20,),
                    Flexible(
                      child: (_time == null)? Text("") : Text(" الوقت ${_time.toString().substring(10,15)}"),
                    )
                  ],
                ),
              ),
            ),
          );
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
                  onChanged: (value) {
                    setState(() {
                      this._finalPageModel[i].testText = value;
                    });
                  },
                  validator: (value) {
                    if (_finalPageModel[i].is_required == true) {
                      if (value.isEmpty) {
                        return "الرجاء تعبئة هذا الحقل";
                      }
                      return null;
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                    labelText: _finalPageModel[i].hint,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
          );
        }

        test.add("_finalPageModel[i].input_type ${i.toString()} ${textEditingController.text.toString()}");
      }



//    for (int i = 0; i < _finalPageModel.length; i++) {
//      // Draw Text Form Field
//      if (_finalPageModel[i].input_type == 'Text') {
//        textFields.add(
//          Padding(
//            padding: const EdgeInsets.only(
//                left: 8.0, right: 8.0, top: 6.0, bottom: 16),
//            child: Container(
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
//                         controller: textEditingController,
//                        keyboardType: (_finalPageModel[i].is_phone == true)
//                            ? TextInputType.phone
//                            : TextInputType.text,
//                        onChanged: (value) {
//                          setState(() {
//                            this._finalPageModel[i].testText = value;
//                          });
//                        },
//                        validator: (value) {
//                          if (_finalPageModel[i].is_required == true) {
//                            if (value.isEmpty) {
//                              return "الرجاء تعبئة هذا الحقل";
//                            }
//                            return null;
//                          }
//                          return null;
//                        },
//                        decoration: InputDecoration(
//                          labelText: _finalPageModel[i].hint,
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
//          ),
//        );//  textFields.add(RaisedButton(onPressed: (){print(_finalPageModel[i].testText);},));
//      }
//      // Draw Radio
//      if (_finalPageModel[i].input_type == 'Radio') {
//        textFields.add(
//          Padding(
//            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0,bottom: 12),
//            child: Container(
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SizedBox(
//                    width: MediaQuery.of(context).size.width * 0.08,
//                  ),
//                  Column(
//                    children: <Widget>[
//                      Visibility(
//                        child: Text(
//                          _finalPageModel[i].hint,
//                          style: TextStyle(
//                              color: ScreenUtileColors.mainBlue,
//                              fontWeight: FontWeight.normal),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Flexible(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          height: 30,
//                          child: Row(
//                            children: <Widget>[
//                              Visibility(
//                                visible: (_finalPageModel[i].option_1 == '')
//                                    ? false
//                                    : true,
//                                child: Radio(
//                                  value: _finalPageModel[i].option_1,
//                                  groupValue: _finalPageModel[i].testText,
//                                  onChanged: (String val) {
//                                    setState(() {
//                                      _finalPageModel[i].testText = val;
//                                      print(_finalPageModel[i].testText);
//                                    });
//                                  },
//                                  activeColor: ScreenUtileColors.mainBlue,
//                                ),
//                              ),
//                              Flexible(
//                                child: Visibility(
//                                  visible: (_finalPageModel[i].option_1 == '')
//                                      ? false
//                                      : true,
//                                  child: Text(
//                                    _finalPageModel[i].option_1,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontWeight: FontWeight.normal),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        Container(
//                          height: 30,
//                          child: Row(
//                            children: <Widget>[
//                              Visibility(
//                                visible: (_finalPageModel[i].option_2 == '')
//                                    ? false
//                                    : true,
//                                child: Radio(
//                                  value: _finalPageModel[i].option_2,
//                                  groupValue: _finalPageModel[i].testText,
//                                  onChanged: (String val) {
//                                    setState(() {
//                                      _finalPageModel[i].testText = val;
//                                      print(_finalPageModel[i].testText);
//                                    });
//                                  },
//                                  activeColor: ScreenUtileColors.mainBlue,
//                                ),
//                              ),
//                              Flexible(
//                                child: Visibility(
//                                  visible: (_finalPageModel[i].option_2 == '')
//                                      ? false
//                                      : true,
//                                  child: Text(
//                                    _finalPageModel[i].option_2,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontWeight: FontWeight.normal),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        Container(
//                          height: 30,
//                          child: Row(
//                            children: <Widget>[
//                              Visibility(
//                                visible: (_finalPageModel[i].option_3 == '')
//                                    ? false
//                                    : true,
//                                child: Radio(
//                                  value: _finalPageModel[i].option_3,
//                                  groupValue: _finalPageModel[i].testText,
//                                  onChanged: (String val) {
//                                    setState(() {
//                                      _finalPageModel[i].testText = val;
//                                      print(_finalPageModel[i].testText);
//                                    });
//                                  },
//                                  activeColor: ScreenUtileColors.mainBlue,
//                                ),
//                              ),
//                              Flexible(
//                                child: Visibility(
//                                  visible: (_finalPageModel[i].option_3 == '')
//                                      ? false
//                                      : true,
//                                  child: Text(
//                                    _finalPageModel[i].option_3,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontWeight: FontWeight.normal),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ),
//        );
//      }
//      // Draw Date
//      if (_finalPageModel[i].input_type == 'Date') {
//        textFields.add(
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  RaisedButton(
//                      color: (_finalPageModel[i].is_required == true)
//                          ? ScreenUtileColors.mainBlue
//                          : Colors.grey,
//                      child: Text(
//                        _finalPageModel[i].hint,
//                        style: TextStyle(color: ScreenUtileColors.fontColor),
//                      ),
//                      onPressed: (_finalPageModel[i].is_required == true)
//                          ? () async {
//                              final selectedDate = await _selectDate(context);
//                              if (selectedDate == null) return;
//                              print(selectedDate);
//                              setState(() {
//                                this._date = DateTime(selectedDate.year,
//                                    selectedDate.month, selectedDate.day);
//                              });
//                            }
//                          : () {}),
//                  SizedBox(width: 20,),
//                  Flexible(
//                      child: (_date == null)
//                          ? Text("")
//                          : Text(
//                              "التاريخ ${_date.toString().substring(0, 10)}")),
//                ],
//              ),
//            ),
//          ),
//        );
//      }
//      // Draw Time
//      if (_finalPageModel[i].input_type == 'Time') {
//        textFields.add(
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                   RaisedButton(
//                      color: (_finalPageModel[i].is_required == true)
//                          ? ScreenUtileColors.mainBlue
//                          : Colors.grey,
//                      child: Text(
//                        _finalPageModel[i].hint,
//                        style: TextStyle(color: ScreenUtileColors.fontColor),
//                      ),
//                      onPressed: (_finalPageModel[i].is_required == true)
//                          ? () async {
//                        final selectedTime = await _selectTime(context);
//                        if (selectedTime == null) return;
//                        print(selectedTime);
//                        setState(() {
//                          this._time = TimeOfDay(
//                            hour: selectedTime.hour,
//                            minute: selectedTime.minute,
//                          );
//                        });
//                      }
//                          : () {}),
//                  SizedBox(width: 20,),
//                  Flexible(
//                      child: (_time == null)? Text("") : Text(" الوقت ${_time.toString().substring(10,15)}"),
//                  )
//                ],
//              ),
//            ),
//          ),
//        );
//      }
//      // Draw Text Area
//      if (_finalPageModel[i].input_type == 'Textarea') {
//        textFields.add(
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Container(
//              width:
//              (screenConfig.screenType == ScreenType.SMALL) ? 300 : 350,
//              decoration: BoxDecoration(
//                border: Border.all(
//                  color: Colors.black,
//                  style: BorderStyle.solid,
//                  width: 1.0,
//                ),
//                color: Colors.transparent,
//                borderRadius: BorderRadius.circular(4.0),
//              ),
//              child: TextFormField(
//                onChanged: (value) {
//                  setState(() {
//                    this._finalPageModel[i].testText = value;
//                  });
//                },
//                validator: (value) {
//                  if (_finalPageModel[i].is_required == true) {
//                    if (value.isEmpty) {
//                      return "الرجاء تعبئة هذا الحقل";
//                    }
//                    return null;
//                  }
//                  return null;
//                },
//                decoration: new InputDecoration(
//                  labelText: _finalPageModel[i].hint,
//                ),
//                maxLines: null,
//                keyboardType: TextInputType.multiline,
//              ),
//            ),
//          ),
//        );
//      }
//
//      test.add("_finalPageModel[i].input_type ${i.toString()} ${_finalPageModel[i].testText}");
//    }
//    for (int i = 0; i < _finalPageModel.length; i++) {
//      if (_finalPageModel[i].input_type == 'Text' && _finalPageModel[i].input_type == 'Textarea') {
//        test.add(_finalPageModel[i].testText);
//        //  textFields.add(RaisedButton(onPressed: (){print(_finalPageModel[i].testText);},));
//      }
//    }
    textFields.add(Container(
      width: MediaQuery.of(context).size.width *0.75,
      child: RaisedButton(
        color: ScreenUtileColors.mainBlue,
        child: Text(
          "شراء",
          style: TextStyle(color: ScreenUtileColors.fontColor),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            print("test $test");
          }else{
            print("test $test");
            Fluttertoast.showToast(msg: 'الرجاء تعبئة كافة الحقول');
          }
        },
      ),
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.serviceNameComing),
        ),
//        body: Container(
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          child: Stack(
//            children: <Widget>[
//              Form(
//                key: _formKey,
//                child: Container(
//                  child: SingleChildScrollView(
//                    child: Column(
//                      children: textFields,
//                    ),
//                  ),
//                ),
//              ),
////              Positioned(
////                bottom: 0,
////                right: 20,
////                left: 20,
////                child: Container(
////                  padding: EdgeInsets.only(
////                    right: 16.0,
////                    left: 16.0,
////                  ),
////                  child: RaisedButton(
////                    color: ScreenUtileColors.mainBlue,
////                    child: Text(
////                      "شراء",
////                      style: TextStyle(color: ScreenUtileColors.fontColor),
////                    ),
////                    onPressed: () {
////                      if(_formKey.currentState.validate()){
////                        print("ok");
////                      }else{
////                        Fluttertoast.showToast(msg: 'الرجاء تعبئة كافة الحقول');
////                      }
////                    },
////                  ),
////                ),
////              )
//            ],
//          ),
//        )
    );
//      body: FutureBuilder(
//        future: helpersApi.printFinalPage(widget.serviceIdComing),
//        builder: (BuildContext context , AsyncSnapshot snapShot){
//          switch (snapShot.connectionState){
//            case ConnectionState.none:
//              error("No Thing Work");
//              break;
//            case ConnectionState.waiting:
//              loading();
//              break;
//            case ConnectionState.active:
//            case ConnectionState.done:
//              if(snapShot.hasError){
//                return error(snapShot.error.toString());
//              }else{
//                if(! snapShot.hasData){
//                  return Container(child: Text('No Data Avilaible'),);
//                }else{
//                  return Container(
//                    height: MediaQuery.of(context).size.height,
//                    width: MediaQuery.of(context).size.width,
//                    child: Stack(
//                      children: <Widget>[
//                        Container(
//                          child: SingleChildScrollView(
//                            child: Column(
//                              children: textFields,
//                            ),
//                          ),
//                        ),
//                        Positioned(
//                          bottom: 0,
//                          right: 20,
//                          left: 20,
//                          child: Container(
//                            padding: EdgeInsets.only(
//                              right: 16.0,
//                              left: 16.0,
//                            ),
//                            child: RaisedButton(
//                              color: ScreenUtileColors.mainBlue,
//                              child: Text(
//                                "شراء",
//                                style: TextStyle(color: ScreenUtileColors.fontColor),
//                              ),
//                              onPressed: () {
//                              },
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  );
//                }
//              }
//              break;
//          }
//          return Container();
//        },
//      ),

  }

//  Widget itemsInCart(List<FinalPageModel> finalPageModel) {
//    for (int i = 0; i < finalPageModel.length; i++) {
//      if (finalPageModel[i].input_type == 'Text') {
//        print(_finalPageModel[i].id);
//        textField.add(
//          Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                SizedBox(
//                  width: MediaQuery.of(context).size.width * 0.1,
//                ),
//                Center(
//                  child: Icon(
//                    Icons.place,
//                    color: ScreenUtileColors.mainBlue,
//                  ),
//                ),
//                SizedBox(
//                  width: 10.0,
//                ),
//                Flexible(
//                  child: Center(
//                    child: TextFormField(
//                      onChanged: (value){
//                          _finalPageModel[i].testText = value;
//                      },
//                      //controller: finalPageModel[i].textEditingController,
//                      validator: (value) {
//                        if (value.isEmpty) {
//                          return finalPageModel[i].hint;
//                        }
//                        return null;
//                      },
//                      textDirection: TextDirection.rtl,
//                      decoration: InputDecoration(
//                        labelText: finalPageModel[i].hint,
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
//                        labelStyle: TextStyle(
//                            fontSize: widgetSize.titleFontSize,
//                            fontWeight: FontWeight.bold,
//                            color: Colors.grey),
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
//        );
//        textField.add(Text(_finalPageModel[i].testText));
//      }
//    }
//    return Container(
//      height: MediaQuery.of(context).size.height,
//      width: MediaQuery.of(context).size.width,
//      child: Stack(
//        children: <Widget>[
//          Container(
//            child: SingleChildScrollView(
//              child: Column(
//                children: textField,
//              ),
//            ),
//          ),
//          Positioned(
//            bottom: 0,
//            right: 20,
//            left: 20,
//            child: Container(
//              padding: EdgeInsets.only(
//                right: 16.0,
//                left: 16.0,
//              ),
//              child: RaisedButton(
//                color: ScreenUtileColors.mainBlue,
//                child: Text(
//                  "شراء",
//                  style: TextStyle(color: ScreenUtileColors.fontColor),
//                ),
//                onPressed: () {
//                },
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }

  /*
   Widget _drawUnits(){
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
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
        child: RaisedButton(
          color: ScreenUtileColors.mainBlue,
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String sessionId = prefs.get('hasSessionId');
            _userName               =    _userNameController.text.toString() ;
            _address                =     _addressController.text.toString() ;
            _carType                =      _carTypeController.text.toString() ;
            _addressCar             =   _addressCarController.text.toString() ;
            _phoneNumberUnitsString = _phoneNumberUnitsController.text.toString();
            List<Map <String,String >> det =[
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
                "new_line":"new_line"
              },
              {
                "heading":"معلومات السيارة"
              },
              {
                "car_type":_carType
              },
              {
                "car_address":_addressCar
              },
              {
                "new_line":"new_line"
              },
              {
                "heading":"تحويل وحدات"
              },
              {
                "phone_Number_Units":_phoneNumberUnitsString
              },
              {
                "unit_value": selectedUnit
              },

            ];
            var response = await helpersApi.addNewOrderDio(
                sessionId, "Battery", det, null);

            if (response.errors_code.length > 0) {
              Fluttertoast.showToast(msg: response.result);
            } else {
              // Fluttertoast.showToast(msg: response.result);
              PublicMethods.showCustomDialog(context, response.result);
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
   */
}
