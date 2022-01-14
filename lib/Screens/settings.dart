import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../style.dart';


class Settings extends StatelessWidget{
  final String userLang;
  final String userType;
  final String userId;
  Settings(this.userLang,this.userType,this.userId);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future<bool> _onBackButtonPressed() {
      Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
    }
    var settingsTranslation = DictionaryLoader(userLang,'/settings');
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Text(settingsTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: PrimaryColor,
          ),
          child: CustomDrawer('SettingsForm'),
        ),
        body: SettingsForm(userLang,userType,userId),
      ),
      onWillPop: _onBackButtonPressed,
    );
  }
}

class SettingsForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final String userId;
  SettingsForm(this.userLang,this.userType,this.userId);

  @override
  SettingsFormState createState() {
    // TODO: implement createState
    return  SettingsFormState(userLang,userType,userId);
  }

}

class SettingsFormState extends State<SettingsForm> {
  final String userLang;
  final String userType;
  final String userId;
  SettingsFormState(this.userLang,this.userType,this.userId);

  @override
  void initState() {
    // TODO: implement initState
    selectedLanguage = userLang;
    super.initState();
  }
  OldPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    passwordOld = await prefs.getString('password');
    //passwordOld = await storage.read(key:'password');
  }

  writeLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language',selectedLanguage);
  }

  List<String> language = <String> ['en', 'hr'];
  String selectedLanguage;
  //final storage = new FlutterSecureStorage();

  final passwordKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureTextConfirm = true;
  Icon icon = new Icon(
    Icons.visibility,
    color: PrimaryColor,
  );
  Icon iconConfirm = new Icon(
    Icons.visibility,
    color: PrimaryColor,
  );
  String password = '';
  String passwordConfirm = '';
  String passwordOld = '';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    var settingsTranslation = DictionaryLoader(userLang,'/settings');
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:EdgeInsets.only(top: 12.0),
          ),
          Text(settingsTranslation.loadDictionary('label_language'),style: FormTextStyle,),
          Padding(
            padding:EdgeInsets.only(top: 4.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: width * 0.2,
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    border: Border.all(),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: selectedLanguage,
                      onChanged: (String value){
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                      items: language.map((val){
                        return DropdownMenuItem(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                    ),
                  )
              ),
              Padding(
                padding:EdgeInsets.only(left: 14.0),
              ),
              Container(
                width: width * 0.3,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  border: Border.all(),
                  color: PrimaryColor,
                ),
                child: RaisedButton(
                  color: PrimaryColor,
                  child: Text(settingsTranslation.loadDictionary('label_done'),style:GridTextStyle),
                  onPressed: (){

                   // storage.write(key: 'language', value: selectedLanguage);
                    writeLang();
                    updateLanguage(userId,selectedLanguage).then((result){
                      print(result);
                      Navigator.pushReplacementNamed(context, SettingsRoute,arguments: {'userLang':selectedLanguage,'userType':userType,'userId':userId});
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 12.0),),
          Container(
            width: width * 0.5,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(),
              color: PrimaryColor,
            ),
            child: RaisedButton(
              color: PrimaryColor,
              child: Text(settingsTranslation.loadDictionary('label_change_password'),style:GridTextStyle),
              onPressed: (){
                showDialog(barrierDismissible: false,context: context, builder: (_)=>new AlertDialog(
                  title: Text(settingsTranslation.loadDictionary('label_conformation')),
                  content: Form(
                    key: passwordKey,
                    child: Container(
                      height: height * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:EdgeInsets.only(top: 12.0),
                          ),
                          Text(settingsTranslation.loadDictionary('label_password'),style: FormTextStyle,),
                          Padding(
                            padding:EdgeInsets.only(top: 4.0),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: const EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              border: Border.all(),
                            ),
                            child: StatefulBuilder(
                              builder: (BuildContext context,StateSetter settStatee){
                                return TextFormField(
                                  obscureText: obscureText,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '${settingsTranslation.loadDictionary('label_password')}';
                                    } else {
                                      password = value.trim();
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: icon,
                                        onPressed: (){
                                          toggle(settStatee);
                                        },
                                      ),
                                      hintText: '${settingsTranslation.loadDictionary('label_password')}',hintStyle: HintTextStyle
                                    //  border: InputBorder.none,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(top: 12.0),
                          ),
                          Text(settingsTranslation.loadDictionary('label_password_confirm'),style: FormTextStyle,),
                          Padding(
                            padding:EdgeInsets.only(top: 4.0),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: const EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              border: Border.all(),
                            ),
                            child: StatefulBuilder(
                              builder: (BuildContext context,StateSetter settStateee){
                                return TextFormField(
                                  obscureText: obscureTextConfirm,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '${settingsTranslation.loadDictionary('label_password_confirm')}';
                                    } else {
                                      passwordConfirm = value.trim();
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: iconConfirm,
                                        onPressed: (){
                                          toggleConfirm(settStateee);
                                        },
                                      ),
                                      hintText: '${settingsTranslation.loadDictionary('label_password_confirm')}',hintStyle: HintTextStyle
                                    //  border: InputBorder.none,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  actions: [
                    FlatButton(
                      child: Text(settingsTranslation.loadDictionary('label_cancel')),
                      onPressed:  () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(settingsTranslation.loadDictionary('label_ok')),
                      onPressed:  () {
                        if(passwordKey.currentState.validate()){
                          OldPassword().then((r){
                            if(password == passwordConfirm){
                              if(password != passwordOld){
                                updatePassword(userId, password).then((result){
                                  if(result == false){
                                    Navigator.of(context).pop();
                                    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text(settingsTranslation.loadDictionary('label_failed')),
                                        content: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 68.0,
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text(settingsTranslation.loadDictionary('label_cancel')),
                                            onPressed:  () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  }else{
                                  /*  storage.write(key: 'password', value: password).then((r){
                                      Navigator.of(context).pop();
                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(settingsTranslation.loadDictionary('label_success')),
                                          content: Icon(
                                            Icons.check,
                                            color: PrimaryColor,
                                            size: 68.0,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(settingsTranslation.loadDictionary('label_return')),
                                              onPressed:  () {
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(context, SettingsRoute,arguments: {'userLang':selectedLanguage,'userType':userType,'userId':userId});
                                              },
                                            ),
                                          ],
                                        );
                                    });
                                    });*/
                                  }
                                });
                              }else{
                                Fluttertoast.showToast(msg: '${settingsTranslation.loadDictionary('label_toast_message_v2')}',
                                  toastLength: Toast.LENGTH_LONG,
                                  fontSize: 16.0,
                                  textColor: Colors.white,
                                  backgroundColor: PrimaryColor,
                                );
                              }
                            }else{
                              Fluttertoast.showToast(msg: '${settingsTranslation.loadDictionary('label_toast_message')}',
                                toastLength: Toast.LENGTH_LONG,
                                fontSize: 16.0,
                                textColor: Colors.white,
                                backgroundColor: PrimaryColor,
                              );
                            }
                          });
                        }
                      },
                    )
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
    toggle(StateSetter settStatee) {
    //function that show password on icon click
     settStatee(() {
      obscureText = !obscureText;
      if (obscureText == false) {
        icon = Icon(
          Icons.visibility_off,
          color: PrimaryColor,
        );
      } else {
        icon = Icon(
          Icons.visibility,
          color: PrimaryColor,
        );
      }
    });
  }
   toggleConfirm(StateSetter settStatee) {
    //function that show password on icon click
     settStatee(() {
      obscureTextConfirm = !obscureTextConfirm;
      if (obscureTextConfirm == false) {
        iconConfirm = Icon(
          Icons.visibility_off,
          color: PrimaryColor,
        );
      } else {
        iconConfirm = Icon(
          Icons.visibility,
          color: PrimaryColor,
        );
      }
    });
  }
}