import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/app.dart';
import 'package:progress_dialog/progress_dialog.dart';



class AddCleaner extends StatelessWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddCleaner(this.userLang,this.userType,this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var addCleanerTranslation = DictionaryLoader(userLang,'/addcleaner');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(data == null ? addCleanerTranslation.loadDictionary('label_title') : addCleanerTranslation.loadDictionary('label_title_2'), style: AppBarTextStyle,),
          iconTheme: IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: PrimaryColor,
        ),
        child: CustomDrawer('CleanersForm'),
        //building a drawer on the left scroll of screen
      ),
      body: AddCleanerForm(userLang,userType,data),
    );
  }
}

class AddCleanerForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddCleanerForm(this.userLang,this.userType,this.data);
  @override
  AddCleanerFormState createState() {
    // TODO: implement createState
    return AddCleanerFormState(userLang,userType,data);
  }
}

class AddCleanerFormState extends State<AddCleanerForm>{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddCleanerFormState(this.userLang,this.userType,this.data);

  final ownerKey = GlobalKey<FormState>();
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone  = '';
  String password = '';
  bool buttonTapped = false;
  RegExp regExp = new RegExp(
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
      caseSensitive: false,
      multiLine: false);
  Icon icon = new Icon(
    Icons.visibility,
    color: PrimaryColor,
  );
  List<String> language = <String> ['en', 'hr'];
  String selectedLanguage;
  bool obscureText = true;
  ProgressDialog pr;
  @override
  void initState() {
    // TODO: implement initState
    if(data !=null){
      setState(() {
        email = data['Username'];
        firstName = data['FirstName'];
        lastName = data['LastName'];
        firstName = data['FirstName'];
        phone = data['phone'];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    var addCleanerTranslation = DictionaryLoader(userLang,'/addcleaner');
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: addCleanerTranslation.loadDictionary('label_checking_data'),
        progressTextStyle: MediumGreenTextStyle,
        messageTextStyle: MediumGreenTextStyle,
        progressWidget: CircularProgressIndicator(),
        elevation: 5,
        backgroundColor: Colors.white
    );
    // TODO: implement build
    print(data);
    return SingleChildScrollView(
      child: Center(
        child: Form(
            key: ownerKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_first_name'),style: FormTextStyle,),
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
                  child: TextFormField(
                    initialValue: data == null ? '':data['FirstName'] ,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addCleanerTranslation.loadDictionary('label_validation_first_name')}';
                      } else {
                        firstName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addCleanerTranslation.loadDictionary('label_first_name')}',hintStyle: HintTextStyle
                      //  border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_last_name'),style: FormTextStyle,),
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
                  child: TextFormField(
                    initialValue: data == null ? '':data['LastName'] ,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addCleanerTranslation.loadDictionary('label_validation_last_name')}';
                      } else {
                        lastName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addCleanerTranslation.loadDictionary('label_last_name')}',hintStyle: HintTextStyle
                      //  border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_password'),style: FormTextStyle,),
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
                  child: TextFormField(
                    readOnly: data != null,
                    initialValue: data == null ? '':data['Password'] ,
                    obscureText: obscureText,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addCleanerTranslation.loadDictionary('label_password')}';
                      } else {
                        password = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: icon,
                          onPressed: toggle,
                        ),
                        hintText: '${addCleanerTranslation.loadDictionary('label_password')}',hintStyle: HintTextStyle
                      //  border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_email'),style: FormTextStyle,),
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
                  child: TextFormField(
                    initialValue: data == null ? '':data['Username'] ,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addCleanerTranslation.loadDictionary('label_validation_email')}';
                      } else if (!regExp.hasMatch(value.trim())) {
                        return '${addCleanerTranslation.loadDictionary('label_validation_email_mistake')}';
                      } else {
                        email = value.trim();
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addCleanerTranslation.loadDictionary('label_email')}',hintStyle: HintTextStyle
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_phone'),style: FormTextStyle,),
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
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: data == null ? '':data['UserPhone'] ,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addCleanerTranslation.loadDictionary('label_validation_phone')}';
                      } else {
                        phone = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addCleanerTranslation.loadDictionary('label_phone')}',hintStyle: HintTextStyle
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addCleanerTranslation.loadDictionary('label_language'),style: FormTextStyle,),
                Padding(
                  padding:EdgeInsets.only(top: 4.0),
                ),
                Container(
                  width: width * 0.5,
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    border: Border.all(),
                  ),
                  child: Center(
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        print(value);
                        if (value == null) {
                          return '${addCleanerTranslation.loadDictionary('label_validation_language')}';
                        } else {
                         // owner = value;
                          return null;
                        }
                      },
                      isDense: true,
                      hint: Text(addCleanerTranslation.loadDictionary('label_select_item')),
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
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Container(
                  width:width * 0.9 ,
                  height: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.white
                  ),
                  child: RaisedButton (
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      onPressed:  () {
                        if (ownerKey.currentState.validate()) {
                          showDialog(barrierDismissible: false,context: context, builder: (_)=>new AlertDialog(
                            title: Text(addCleanerTranslation.loadDictionary('label_conformation')),
                            content: Text(addCleanerTranslation.loadDictionary('label_question')),
                            actions: [
                              FlatButton(
                                child: Text(addCleanerTranslation.loadDictionary('label_cancel')),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(addCleanerTranslation.loadDictionary('label_ok')),
                                onPressed:  () {
                                  pr.show();
                                  firstName = firstName.substring(0,1).toUpperCase() + firstName.substring(1,firstName.length);
                                  lastName = lastName.substring(0,1).toUpperCase() + lastName.substring(1,lastName.length);
                                  if(data != null){

                                    EditCleaners(firstName, lastName, email, phone, data['UserType'], data['Language'], data['UserID']).then((result){
                                      if(result == false){
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addCleanerTranslation.loadDictionary('label_failed')),
                                            content: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addCleanerTranslation.loadDictionary('label_cancel')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }else{
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addCleanerTranslation.loadDictionary('label_success')),
                                            content: Icon(
                                              Icons.check,
                                              color: PrimaryColor,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addCleanerTranslation.loadDictionary('label_return')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(context, CleanersRoute,arguments: {'userLang':userLang,'userType':userType});
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }
                                    });
                                  }else{
                                    addCleaner(firstName,lastName,email,phone,selectedLanguage,password).then((result){
                                      if(result == false){
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addCleanerTranslation.loadDictionary('label_failed')),
                                            content: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addCleanerTranslation.loadDictionary('label_cancel')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }else{
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addCleanerTranslation.loadDictionary('label_success')),
                                            content: Icon(
                                              Icons.check,
                                              color: PrimaryColor,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addCleanerTranslation.loadDictionary('label_return')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(context, CleanersRoute,arguments: {'userLang':userLang,'userType':userType});
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }
                                    });
                                  }

                                },
                              )
                            ],
                          )
                          );
                        }
                      },
                      child: Container(
                        width:width * 0.9 ,
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
                          '${data == null ? addCleanerTranslation.loadDictionary('label_add') : addCleanerTranslation.loadDictionary('label_edit')}',
                          style: RegularButtonTextStyle,textAlign: TextAlign.center,
                        ),
                      )
                  ),

                ),
              ],
            )
        ),
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