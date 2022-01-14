import 'package:Domenitos/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Domenitos/app.dart';
import 'package:Domenitos/Screens/homepage.dart';


class Login extends StatelessWidget {
  Future<bool> onBackButtonPressed() {
    //function which if back button is pressed exits the app
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        child: Scaffold(
          body: MyLoginForm(),
        ),
        onWillPop: onBackButtonPressed
    );
  }
}

class MyLoginForm extends StatefulWidget {

  @override
  MyLoginFormState createState() {
    return MyLoginFormState();
  }
}

class MyLoginFormState extends State<MyLoginForm> {
  final formKey = GlobalKey<FormState>();

  //final storage = new FlutterSecureStorage();
  var future;
  bool authenticationCheck = true;
  double size ;
  double appwidth;
  String authenticationState = '';
  String emailStorage = '';
  String passwordStorage = '';
  String authentication= '';
  String userLang ='';
  String userType ='';
  Locale myLocale;
  var loginTranslation;
  bool obscureText = true;
  Icon icon = new Icon(
    Icons.visibility,
    color: PrimaryColor,
  );
  String email = '';
  RegExp regExp = new RegExp(
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
      caseSensitive: false,
      multiLine: false);
  String password = '';
  bool buttonTapped = false;
  ProgressDialog pr;
  String session = '';
  DateTime now = DateTime.now().toLocal();
  DateTime Session;

  @override
  void initState() {
    // TODO: implement initState
    //_clear_storage();
    _authenticationCheck().then((result){

        if(authenticationState == 'YES'){
          future= LoginConformation(emailStorage,passwordStorage).then((result){
            authenticationCheck = result;

            if(authenticationCheck == false){
              _clear_storage().then((result){
                Navigator.pushReplacementNamed(context, LoginRoute);
              });
            }else{
              _session_check().then((result){
                session = session.substring(0,19);
                session = session.substring(0, 10) + "T" + session.substring(11);
                Session = DateTime.parse(session);
                var diff = now.difference(Session);
                print(diff.inSeconds);
                if(diff.inDays > 30){
                  setState(() {
                    authenticationState = 'NO';
                    _clear_storage().then((result){
                      Navigator.pushReplacementNamed(context, LoginRoute);
                    });
                  });
                }else{
                  setState(() {
                    pr.hide();
                    authentication = 'YES';
                    _authentication();
                    buttonTapped = false;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(userLang,userType)));

                  });
                }
              });
            }
          });
        }else{
          setState(() {
            authenticationState = 'NO';
            authenticationCheck = false;

            future = getfalse();
          });
        }
    });
    super.initState();
  }

  _authenticationCheck() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = await prefs.getString('userType');
    authenticationState = await prefs.getString('authentication');
    emailStorage = await prefs.getString('username');
    passwordStorage = await prefs.getString('password');
    userLang = await prefs.getString('userLang');
   /* authenticationState = await storage.read(key:'authentication');
    emailStorage = await storage.read(key:'username');
    passwordStorage = await storage.read(key: 'password');
    userType = await storage.read(key:'userType');
    userLang = await storage.read(key: 'language');*/

  }
  _authentication() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('authentication', authentication);
      //storage.write(key: 'authentication', value: authentication);
    });
  }
  _clear_storage() async {
    //deleting everything in storage
    //await storage.deleteAll();
  }
  _session_check() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    session = await prefs.getString('session');

    //session = await storage.read(key: 'session');
  }

  @override
  Widget build(BuildContext context) {
    myLocale = Localizations.localeOf(context);
    appwidth = MediaQuery.of(context).size.width;//width of the screen
    loginTranslation  =DictionaryLoader(myLocale.languageCode.toString(),'/login');
    if(appwidth > 768){
      size = 0.5;
    }else{
      size= 0.7;
    }
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: loginTranslation.loadDictionary('label_checking_data'),
      progressTextStyle: MediumGreenTextStyle,
      messageTextStyle: MediumGreenTextStyle,
      progressWidget: CircularProgressIndicator(),
      elevation: 5,
      backgroundColor: Colors.white
    );

    // TODO: implement build
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: new CircularProgressIndicator(),
          );
        }else if(authenticationCheck){
          return Center(
            child: new CircularProgressIndicator(),
          );
        }else{
          return Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     logo(),
                     Padding(
                         padding:EdgeInsets.only(top: 22.0),
                     ),
                      usernamePassword(size),
                      Padding(
                          padding:  EdgeInsets.only(top: 12.0),
                      ),
                      login(size),
                    ]
                ),
              ),
            ),
          );
        }
      },
    );
  }
  Container logo(){
    return Container(
      child: Image.asset('assets/images/DomenitosLogo.png')
    );
  }
  Container usernamePassword(double size) {
    //container with form field of email and password
    return Container(
      width: appwidth * size,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return '${loginTranslation.loadDictionary('label_validation_email')}';
              } else if (!regExp.hasMatch(value.trim())) {
                return '${loginTranslation.loadDictionary('label_validation_email_mistake')}';
              } else {
                email = value.trim();
                return null;
              }
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: PrimaryColor,
                ),
                hintText: '${loginTranslation.loadDictionary('label_email')}',hintStyle: HintTextStyle
          ),
          ),
          TextFormField(
            obscureText: obscureText,
            validator: (value) {
              if (value.isEmpty) {
                return '${loginTranslation.loadDictionary('label_validation_password')}';
              } else {
                password = value;
                return null;
              }
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.lock,
                  color: PrimaryColor,
                ),
                suffixIcon: IconButton(
                  icon: icon,
                  onPressed: toggle,
                ),
                hintText: '${loginTranslation.loadDictionary('label_password')}',hintStyle: HintTextStyle
                //  border: InputBorder.none,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          )),
    );
  }
  Container login(double size){
    return Container(
      width:appwidth * size ,
      height: 42,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Colors.white
      ),
      child: RaisedButton (
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: buttonTapped ? null : () {
            buttonTapped = true;
            if (formKey.currentState.validate()) {
              //validationg for if it is ok procesing login
              pr.show();
              print('clic');
              getLoginInformation(email,password).then((result) {
                //cheking login information
                if (result == false) {
                  pr.hide();
                  Fluttertoast.showToast(msg: '${loginTranslation.loadDictionary('label_toast_message')}',
                      toastLength: Toast.LENGTH_LONG,
                      fontSize: 16.0,
                      textColor: Colors.white,
                      backgroundColor: PrimaryColor,
                      );
                  authentication = 'NO';
                  _authentication();
                  buttonTapped = false;
                } else if (result = true) {
                  pr.hide();
                  authentication = 'YES';
                  _authentication();
                  buttonTapped = false;
                  _authenticationCheck().then((result){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(userLang,userType)));
                  });
                 //go to home screen

                }
              });
            }
          },
          child: Container(
            width:appwidth * size ,
            height: 42,
            padding: const EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  PrimaryColor,
                  PrimaryColor.shade700
                ],
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Text(
              '${loginTranslation.loadDictionary('label_login')}',
              style: RegularButtonTextStyle,textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }
  void toggle() {
    //function that show password on icon click
    setState(() {
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
}