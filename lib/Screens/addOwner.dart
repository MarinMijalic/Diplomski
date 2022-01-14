import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/app.dart';
import 'package:progress_dialog/progress_dialog.dart';



class AddOwner  extends StatelessWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddOwner(this.userLang,this.userType,this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var addOwnerTranslation = DictionaryLoader(userLang,'/addowner');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(data == null ? addOwnerTranslation.loadDictionary('label_title') : addOwnerTranslation.loadDictionary('label_title_2'),style: AppBarTextStyle,),
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
        child: CustomDrawer('OwnersForm'),
        //building a drawer on the left scroll of screen
      ),
      body: AddOwnersForm(userLang,userType,data),
    );
  }
}

class AddOwnersForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddOwnersForm(this.userLang,this.userType,this.data);
  @override
  AddOwnersFormState createState() {
    // TODO: implement createState
    return AddOwnersFormState(userLang,userType,data);
  }
}

class AddOwnersFormState extends State<AddOwnersForm>{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddOwnersFormState(this.userLang,this.userType,this.data);

  final ownerKey = GlobalKey<FormState>();
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone  = '';
  bool buttonTapped = false;
  RegExp regExp = new RegExp(
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
      caseSensitive: false,
      multiLine: false);
  ProgressDialog pr;
  @override
  void initState() {
    // TODO: implement initState
    if(data != null){
      setState(() {
        firstName = data['OwnerName'];
        lastName = data['OwnerLastName'];
        email = data['OwnerEmail'];
        phone = data['OwnerPhone'];
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
    var addOwnerTranslation = DictionaryLoader(userLang,'/addowner');
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: addOwnerTranslation.loadDictionary('label_checking_data'),
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
                Text(addOwnerTranslation.loadDictionary('label_first_name'),style: FormTextStyle,),
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
                    initialValue: data == null ? '':data['OwnerName'] ,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addOwnerTranslation.loadDictionary('label_validation_first_name')}';
                      } else {
                        firstName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addOwnerTranslation.loadDictionary('label_first_name')}',hintStyle: HintTextStyle
                      //  border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addOwnerTranslation.loadDictionary('label_last_name'),style: FormTextStyle,),
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
                    initialValue: data == null ? '':data['OwnerLastName'] ,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addOwnerTranslation.loadDictionary('label_validation_last_name')}';
                      } else {
                        lastName = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addOwnerTranslation.loadDictionary('label_last_name')}',hintStyle: HintTextStyle
                      //  border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addOwnerTranslation.loadDictionary('label_email'),style: FormTextStyle,),
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
                    initialValue: data == null ? '':data['OwnerEmail'] ,
                    validator: (value) {
                      print(value);
                      print('test');
                      if (value.isEmpty) {
                        return '${addOwnerTranslation.loadDictionary('label_validation_email')}';
                      } else if (!regExp.hasMatch(value.trim())) {
                        return '${addOwnerTranslation.loadDictionary('label_validation_email_mistake')}';
                      } else {
                        email = value.trim();
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addOwnerTranslation.loadDictionary('label_email')}',hintStyle: HintTextStyle
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(top: 12.0),
                ),
                Text(addOwnerTranslation.loadDictionary('label_phone'),style: FormTextStyle,),
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
                    initialValue: data == null ? '':data['OwnerPhone'] ,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '${addOwnerTranslation.loadDictionary('label_validation_phone')}';
                      } else {
                        phone = value;
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${addOwnerTranslation.loadDictionary('label_phone')}',hintStyle: HintTextStyle
                    ),
                  ),
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
                            title: Text(addOwnerTranslation.loadDictionary('label_conformation')),
                            content: Text(addOwnerTranslation.loadDictionary('label_question')),
                            actions: [
                              FlatButton(
                                child: Text(addOwnerTranslation.loadDictionary('label_cancel')),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(addOwnerTranslation.loadDictionary('label_ok')),
                                onPressed:  () {
                                  pr.show();
                                  firstName = firstName.substring(0,1).toUpperCase() + firstName.substring(1,firstName.length);
                                  lastName = lastName.substring(0,1).toUpperCase() + lastName.substring(1,lastName.length);
                                  if(data !=null){
                                    print(firstName);
                                    EditOwner(firstName, lastName, phone, email, data['OwnersID']).then((result){
                                      if(result == false){
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addOwnerTranslation.loadDictionary('label_failed')),
                                            content: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addOwnerTranslation.loadDictionary('label_cancel')),
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
                                            title: Text(addOwnerTranslation.loadDictionary('label_success')),
                                            content: Icon(
                                              Icons.check,
                                              color: PrimaryColor,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addOwnerTranslation.loadDictionary('label_return')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(context, OwnersRoute,arguments: {'userLang':userLang,'userType':userType});
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }
                                    });
                                  }else{
                                    addOwner(firstName, lastName, email, phone).then((result){
                                      if(result == false){
                                        pr.hide();
                                        Navigator.of(context).pop();
                                        showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(addOwnerTranslation.loadDictionary('label_failed')),
                                            content: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addOwnerTranslation.loadDictionary('label_cancel')),
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
                                            title: Text(addOwnerTranslation.loadDictionary('label_success')),
                                            content: Icon(
                                              Icons.check,
                                              color: PrimaryColor,
                                              size: 68.0,
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(addOwnerTranslation.loadDictionary('label_return')),
                                                onPressed:  () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(context, OwnersRoute,arguments: {'userLang':userLang,'userType':userType});
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
                          '${data == null ? addOwnerTranslation.loadDictionary('label_add') : addOwnerTranslation.loadDictionary('label_edit')}',
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

}