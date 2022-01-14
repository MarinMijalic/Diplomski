import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:geocoder/services/base.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../style.dart';


class AddApartments extends StatelessWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddApartments(this.userLang,this.userType,this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var addApartmentTranslation = DictionaryLoader(userLang,'/addapartment');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(data == null ? addApartmentTranslation.loadDictionary('label_title') : addApartmentTranslation.loadDictionary('label_title_2'),style: AppBarTextStyle,),
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
        child: CustomDrawer('ApartmentsForm'),
        //building a drawer on the left scroll of screen
      ),
      body: AddApartmentsForm(userLang,userType,data),
    );
  }
}

class AddApartmentsForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddApartmentsForm(this.userLang,this.userType,this.data);
  @override
  AddApartmentsFormState createState() {
    // TODO: implement createState
    return AddApartmentsFormState(userLang,userType,data);
  }
}

class AddApartmentsFormState extends State<AddApartmentsForm>{
  final String userLang;
  final String userType;
  final Map<String,dynamic> data;
  AddApartmentsFormState(this.userLang,this.userType,this.data);

  var future;
  final apartmentKey = GlobalKey<FormState>();
  List<dynamic> owners = new List<dynamic>();
  String selectedOwner;
  String address = '';
  String description = '';
  String squares = '';
  String city = '';
  //List<Address> results = [];
  final TextEditingController _controller= new TextEditingController();
  bool isLoading = false;
  String fulladdress = '';
  String latitude ='';
  String longitude ='';
  String owner = '';
  ProgressDialog pr;

  Future search() async {
    print(_controller.text + city);
    //var addresses = await Geocoder.local.findAddressesFromQuery(_controller.text + ',' +city);
    setState(() {
     /* fulladdress = addresses.first.addressLine;
      latitude = addresses.first.coordinates.latitude.toString();
      longitude = addresses.first.coordinates.longitude.toString();*/
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    future = getOwnerInformation().then((result){
      result.forEach((value){
        value.forEach((key,value2){
          if(key == 'OwnersID'){
            String pomoc = value['OwnerName'] + ' ' + value['OwnerLastName'];
            if(data != null){
              if(value2 == data['OwnerID']){
                    setState(() {

                      selectedOwner = pomoc;
                      _controller.text = data['Address'];
                      description = data['Description'];
                      squares = data['Squares'];
                      city = data['City'];
                    });
              }
            }
            owners.add({"Owner":{"OwnerId":value2,"OwnerName":pomoc}});
          }
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery
        .of(context)
        .size
        .width;

    var addApartmentTranslation = DictionaryLoader(userLang,'/addapartment');
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: addApartmentTranslation.loadDictionary('label_checking_data'),
        progressTextStyle: MediumGreenTextStyle,
        messageTextStyle: MediumGreenTextStyle,
        progressWidget: CircularProgressIndicator(),
        elevation: 5,
        backgroundColor: Colors.white
    );
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(owners == null && snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: new CircularProgressIndicator(),
          );
        }else if(owners == null && snapshot.connectionState == ConnectionState.done){
          return Center(
            child: Text(addApartmentTranslation.loadDictionary('label_msg_nothing'),style: BigGreenTextStyle,),
          );
        }else{
          print(data);
          return SingleChildScrollView(
            child: Center(
              child: Form(
                key: apartmentKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top: 12.0),
                    ),
                    Text(addApartmentTranslation.loadDictionary('label_owner'),style: FormTextStyle,),
                    Padding(
                      padding:EdgeInsets.only(top: 4.0),
                    ),
                    Container(
                        width: width * 0.6,
                        padding: const EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(),
                        ),
                        child: Center(
                          child: DropdownButtonFormField<dynamic>(
                            validator: (value) {
                              print(value);
                              if (value == null) {
                                return '${addApartmentTranslation.loadDictionary('label_validation_owner')}';
                              } else {
                                owner = value;
                                return null;
                              }
                            },
                            isDense: true,
                            hint: Text(addApartmentTranslation.loadDictionary('label_select_owner')),
                            value: selectedOwner,
                            onChanged: (dynamic value){
                              print(value);
                              setState(() {
                                selectedOwner = value;
                              });
                            },
                            items: owners.map((val){
                              return DropdownMenuItem(
                                value: val['Owner']['OwnerName'],
                                child: Text(val['Owner']['OwnerName'].toString()),
                              );
                            }).toList(),
                          ),
                        )
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: 12.0),
                    ),
                    Text(addApartmentTranslation.loadDictionary('label_address'),style: FormTextStyle,),
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
                        controller: _controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${addApartmentTranslation.loadDictionary('label_validation_address')}';
                          } else {
                            address = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${addApartmentTranslation.loadDictionary('label_address')}',hintStyle: HintTextStyle
                        ),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: 12.0),
                    ),
                    Text(addApartmentTranslation.loadDictionary('label_description'),style: FormTextStyle,),
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
                        initialValue: data == null ? '':data['Description'] ,
                          maxLength: 400,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${addApartmentTranslation.loadDictionary('label_validation_description')}';
                          } else {
                            description = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${addApartmentTranslation.loadDictionary('label_description')}',hintStyle: HintTextStyle
                        ),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: 12.0),
                    ),
                    Text(addApartmentTranslation.loadDictionary('label_squares'),style: FormTextStyle,),
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
                        initialValue:data == null ?  '': data['Squares'],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${addApartmentTranslation.loadDictionary('label_validation_squares')}';
                          } else {
                             squares = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${addApartmentTranslation.loadDictionary('label_squares')}',hintStyle: HintTextStyle
                        ),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(top: 12.0),
                    ),
                    Text(addApartmentTranslation.loadDictionary('label_city'),style: FormTextStyle,),
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
                        initialValue:data == null ?'' : data['City'],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '${addApartmentTranslation.loadDictionary('label_validation_city')}';
                          } else {
                            city = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${addApartmentTranslation.loadDictionary('label_city')}',hintStyle: HintTextStyle
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(12.0),
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
                            if (apartmentKey.currentState.validate()) {
                              print(owner);
                              showDialog(barrierDismissible: false,context: context, builder: (_)=>new AlertDialog(
                                title: Text(addApartmentTranslation.loadDictionary('label_conformation')),
                                content: Text(addApartmentTranslation.loadDictionary('label_question')),
                                actions: [
                                  FlatButton(
                                    child: Text(addApartmentTranslation.loadDictionary('label_cancel')),
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(addApartmentTranslation.loadDictionary('label_ok')),
                                    onPressed:  () {
                                        String ownerid = '';
                                        owners.forEach((value){
                                          if(value['Owner']['OwnerName'] == selectedOwner){
                                            ownerid = value['Owner']['OwnerId'];
                                          }
                                        });
                                        pr.show();
                                        search().then((result){
                                          if(data != null){
                                            EditApartment(description, squares, address,data['Zipcode'],city,data['Country'], latitude, longitude, data['ApartmentID'],ownerid).then((result){
                                              if(result == false){
                                                pr.hide();
                                                Navigator.of(context).pop();
                                                showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                                  return AlertDialog(
                                                    title: Text(addApartmentTranslation.loadDictionary('label_failed')),
                                                    content: Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 68.0,
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(addApartmentTranslation.loadDictionary('label_cancel')),
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
                                                    title: Text(addApartmentTranslation.loadDictionary('label_success')),
                                                    content: Icon(
                                                      Icons.check,
                                                      color: PrimaryColor,
                                                      size: 68.0,
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(addApartmentTranslation.loadDictionary('label_return')),
                                                        onPressed:  () {
                                                          Navigator.of(context).pop();
                                                          Navigator.pushReplacementNamed(context, ApartmentsRoute,arguments: {'userLang':userLang,'userType':userType});

                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              }
                                            });
                                          }else{
                                            AddApartment(description,squares,fulladdress,latitude,longitude,ownerid).then((result){
                                              if(result == false){
                                                pr.hide();
                                                Navigator.of(context).pop();
                                                showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                                  return AlertDialog(
                                                    title: Text(addApartmentTranslation.loadDictionary('label_failed')),
                                                    content: Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 68.0,
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(addApartmentTranslation.loadDictionary('label_cancel')),
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
                                                    title: Text(addApartmentTranslation.loadDictionary('label_success')),
                                                    content: Icon(
                                                      Icons.check,
                                                      color: PrimaryColor,
                                                      size: 68.0,
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text(addApartmentTranslation.loadDictionary('label_return')),
                                                        onPressed:  () {
                                                          Navigator.of(context).pop();
                                                          Navigator.pushReplacementNamed(context, ApartmentsRoute,arguments: {'userLang':userLang,'userType':userType});

                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              }
                                            });
                                          }

                                        });
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
                              '${data == null ? addApartmentTranslation.loadDictionary('label_add') : addApartmentTranslation.loadDictionary('label_edit')}',
                              style: RegularButtonTextStyle,textAlign: TextAlign.center,
                            ),
                          )
                      ),

                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

}