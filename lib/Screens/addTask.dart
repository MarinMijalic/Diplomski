import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTask extends StatelessWidget{
  final String userLang;
  final String userType;
  AddTask(this.userLang,this.userType);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var addTaskTranslation = DictionaryLoader(userLang,'/addTask');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(addTaskTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
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
        child: CustomDrawer('TasksForm'),
        //building a drawer on the left scroll of screen
      ),
      body: AddTaskForm(userLang,userType),
    );
  }
}

class AddTaskForm extends StatefulWidget{
  final String userLang;
  final String userType;
  AddTaskForm(this.userLang,this.userType);
  @override
  AddTaskFormState createState() {
    // TODO: implement createState
    return AddTaskFormState(userLang,userType);
  }
}

class AddTaskFormState extends State<AddTaskForm>{
  final String userLang;
  final String userType;
  AddTaskFormState(this.userLang,this.userType);


  var future;
  final  taskKey = GlobalKey<FormState>();
  List<dynamic> cleaners = [];
  List<dynamic> apartments = [];
  String selectedCleaner;
  String Cleaner = '';
  String Apartment= '';
  String description = '';
  DateTime  now = DateTime.now();
  String date =  'Enter Date:';
  String time = 'Enter Time:';
  String companyId = '';
  String selectedApartment;
  ProgressDialog pr;
  @override
  void initState() {
    // TODO: implement initState
    readCompanyId().then((result){
      if(userType.isNotEmpty){
        setState(() {
        });
      }
    });
    future = getCleanerInformation().then((result){
      result.forEach((value){
        value.forEach((key,value2){
          if(key == 'UserID'){
            String pomoc = value['FirstName'] + ' ' + value['LastName'];
            cleaners.add({"Cleaner":{"CleanerId":value2,"CleanerName":pomoc}});
          }
        });
      });
    });
    super.initState();
    getApartments().then((result){

      result.forEach((value){

        value.forEach((key,value2){
          if(key == 'CompanyID'){
            if(value2 == companyId){
              print(value['ApartmentID']);
              print('test');
              setState(() {
                apartments.add({"Apartment":{"ApartmentID":value['ApartmentID'],"Address":value['Address'] }});
              });

            }
          }
        });
      });
    });
  }
  readCompanyId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId  = await prefs.getString('companyID');
    //companyId = await storage.read(key:'companyID');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var addTaskTranslation = DictionaryLoader(userLang,'/addTask');
    double width = MediaQuery
        .of(context)
        .size
        .width;
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: addTaskTranslation.loadDictionary('label_checking_data'),
        progressTextStyle: MediumGreenTextStyle,
        messageTextStyle: MediumGreenTextStyle,
        progressWidget: CircularProgressIndicator(),
        elevation: 5,
        backgroundColor: Colors.white
    );
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(apartments == null && snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: new CircularProgressIndicator(),
            );
          }else if(apartments == null && snapshot.connectionState == ConnectionState.done){
            return Center(
              child: Text(addTaskTranslation.loadDictionary('label_msg_nothing'),style: BigGreenTextStyle,),
            );
          }else{
            return SingleChildScrollView(
              child: Center(
                child: Form(
                  key: taskKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:EdgeInsets.only(top: 12.0),
                      ),
                      Text(addTaskTranslation.loadDictionary('label_cleaner'),style: FormTextStyle,),
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
                                if (value == null) {
                                  return '${addTaskTranslation.loadDictionary('label_validation_cleaner')}';
                                } else {
                                  Cleaner = value;
                                  return null;
                                }
                              },
                              isDense: true,
                              hint: Text(addTaskTranslation.loadDictionary('label_select_cleaner')),
                              value: selectedCleaner,
                              onChanged: (dynamic value){
                                setState(() {
                                  selectedCleaner = value;
                                });
                              },
                              items: cleaners.map((val){
                                return DropdownMenuItem(
                                  value: val['Cleaner']['CleanerId'],
                                  child: Text(val['Cleaner']['CleanerName'].toString()),
                                );
                              }).toList(),
                            ),
                          ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top: 12.0),
                      ),
                      Text(addTaskTranslation.loadDictionary('label_apartment'),style: FormTextStyle,),
                      Padding(
                        padding:EdgeInsets.only(top: 4.0),
                      ),
                      Container(
                        width: width * 0.8,
                        padding: const EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(),
                        ),
                        child: Center(
                          child: DropdownButtonFormField<dynamic>(
                            validator: (value) {
                              if (value == null) {
                                return '${addTaskTranslation.loadDictionary('label_validation_apartment')}';
                              } else {
                                Apartment = value;
                                return null;
                              }
                            },
                            isDense: true,
                            hint: Text(addTaskTranslation.loadDictionary('label_select_apartment')),
                            value: selectedApartment,
                            onChanged: (dynamic value){
                              setState(() {
                                selectedApartment = value;
                              });
                            },
                            items: apartments.map((val){
                              return DropdownMenuItem(
                                value: val['Apartment']['ApartmentID'].toString(),
                                child: Text(val['Apartment']['Address'].toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top: 12.0),
                      ),
                      Text(addTaskTranslation.loadDictionary('label_description'),style: FormTextStyle,),
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
                          maxLength: 400,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '${addTaskTranslation.loadDictionary('label_description')}',hintStyle: HintTextStyle
                          ),
                          validator: (value){
                            description = value;
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top: 12.0),
                      ),
                      Text(addTaskTranslation.loadDictionary('label_date_picker'),style: FormTextStyle,),
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
                            readOnly: true,
                            onTap: (){
                              DatePicker.showDatePicker(
                                  context,
                                  minTime: now,
                                  maxTime: DateTime(now.year+1,now.month,now.day),
                                  locale: LocaleType.en,
                                  onConfirm: (d){
                                    setState(() {
                                      var pom  = d.toString().split(' ');
                                      date = pom[0];
                                    });
                                  }
                              );
                            },
                            validator: (value) {
                              if (date == 'Enter Date:') {
                                return '${addTaskTranslation.loadDictionary('label_validation_date')}';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: date,hintStyle: FormTextStyle
                            ),
                          )
                      ),
                      Padding(
                        padding:EdgeInsets.only(top: 12.0),
                      ),
                      Text(addTaskTranslation.loadDictionary('label_time_picker'),style: FormTextStyle,),
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
                            readOnly: true,
                            onTap: (){
                              DatePicker.showTimePicker(
                                  context,
                                  currentTime: now,
                                  showSecondsColumn: false,
                                  locale: LocaleType.en,
                                  onConfirm: (d){
                                    setState(() {
                                      var pom  = d.toString().split(' ');
                                      time = pom[1].substring(0,5);
                                    });
                                  }
                              );
                            },
                            validator: (value) {
                              if (time == 'Enter Time:') {
                                return '${addTaskTranslation.loadDictionary('label_validation_time')}';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: time,hintStyle: FormTextStyle
                            ),
                          )
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

                              if (taskKey.currentState.validate()) {
                                print(selectedCleaner);
                                print(selectedApartment);
                                print(description);
                                print(date);
                                print(time);
                                showDialog(barrierDismissible: false,context: context, builder: (_)=>new AlertDialog(
                                  title: Text(addTaskTranslation.loadDictionary('label_conformation')),
                                  content: Text(addTaskTranslation.loadDictionary('label_question')),
                                  actions: [
                                    FlatButton(
                                      child: Text(addTaskTranslation.loadDictionary('label_cancel')),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(addTaskTranslation.loadDictionary('label_ok')),
                                      onPressed:  () {
                                        pr.show();
                                        addTaskJson(selectedCleaner,selectedApartment,description,date,time).then((result){
                                            if(result == false){
                                              pr.hide();
                                              Navigator.of(context).pop();
                                              showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text(addTaskTranslation.loadDictionary('label_failed')),
                                                  content: Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                    size: 68.0,
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(addTaskTranslation.loadDictionary('label_cancel')),
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
                                                  title: Text(addTaskTranslation.loadDictionary('label_success')),
                                                  content: Icon(
                                                    Icons.check,
                                                    color: PrimaryColor,
                                                    size: 68.0,
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(addTaskTranslation.loadDictionary('label_return')),
                                                      onPressed:  () {
                                                        Navigator.of(context).pop();
                                                        Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':selectedCleaner});
                                                      },
                                                    ),
                                                  ],
                                                );
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
                                '${addTaskTranslation.loadDictionary('label_add')}',
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
        }
    );
  }

}
