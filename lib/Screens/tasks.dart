import 'package:Domenitos/Classes/Error_Logger.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../style.dart';


class Tasks extends StatelessWidget{
  final String userLang;
  final String userType;
  final String userId;
  Tasks(this.userLang,this.userType,this.userId);

  @override
  Widget build(BuildContext context) {

    Future<bool> _onBackButtonPressed() {
      Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
    }
    var tasksTranslation = DictionaryLoader(userLang,'/tasks');
    // TODO: implement build
    if(userType == 'superadmin' || userType == 'admin'){
      return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: PrimaryColor,
            onPressed: (){
              Navigator.pushNamed(context, AddTaskRoute,arguments: {'userLang':userLang,'userType':userType});
            },
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              title: Text(tasksTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: PrimaryColor,
            ),
            child: CustomDrawer('TasksForm'),
          ),
          body: TasksForm(userLang,userType,userId),
        ),
        onWillPop: _onBackButtonPressed,
      );
    }else{
      return WillPopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              title: Text(tasksTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: PrimaryColor,
            ),
            child: CustomDrawer('TasksForm'),
          ),
          body: TasksForm(userLang,userType,userId),
        ),
        onWillPop: _onBackButtonPressed,
      );
    }

  }

}

class TasksForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final String userId;
  TasksForm(this.userLang,this.userType,this.userId);
  @override
  TasksFormState createState() {
    // TODO: implement createState
    return TasksFormState(userLang,userType,userId);
  }
}

class TasksFormState extends State<TasksForm>{
  final String userLang;
  final String userType;
  final String userId;
  TasksFormState(this.userLang,this.userType,this.userId);

  var future;
  List<dynamic> cleaners = [];
  String SelectedClener;
  List test = ['item1', 'item2'];
  bool changer = false;
  @override
  void initState() {
    // TODO: implement initState
    future = getTasks();
    super.initState();
    getCleanerInformation().then((result){
      result.forEach((value){
        value.forEach((key,value2){
          if(key == 'UserID'){
            String pomoc = value['FirstName'] + ' ' + value['LastName'];
            cleaners.add({"Cleaner":{"CleanerId":value2,"CleanerName":pomoc}});
          }
        });
      });
      cleaners.forEach((value){
        if(value['Cleaner']['CleanerId'] == userId){
          setState(() {
            SelectedClener = value['Cleaner']['CleanerId'];
          });
        }
      });
      if(SelectedClener == null){
        setState(() {
          SelectedClener = cleaners[0]['Cleaner']['CleanerId'];
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery
        .of(context)
        .size
        .width;
    var tasksTranslation = DictionaryLoader(userLang,'/tasks');
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null && snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: new CircularProgressIndicator(),
            );
          }else if(snapshot.data ==null && snapshot.connectionState == ConnectionState.done){
            return Center(
              child: new CircularProgressIndicator(),
            );
          }else{
            int len = snapshot.data.length;
            if(userType == 'superadmin' || userType=='admin' ){
              changer = true;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(4.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
                            return cleanerss(width,tasksTranslation,index);
                          },
                          childCount: 1
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top:4.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
                            return TaskCards(snapshot.data,index,SelectedClener,tasksTranslation,width);
                          },
                          childCount: len
                      ),
                    ),
                  ),
                ],
              );
            }else{
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top:4.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
                            return TaskCards(snapshot.data,index,userId,tasksTranslation,width);
                          },
                          childCount: len
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        });
  }
  Column cleanerss(double width, DictionaryLoader tasksTranslation,int index){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 12.0)),
          Text(tasksTranslation.loadDictionary('label_cleaner_filter'),style: FormTextStyle,),
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
            child: DropdownButton(
              //isDense: true,
              hint: Text(tasksTranslation.loadDictionary('label_select_owner')),
              value: SelectedClener,
              onChanged: (dynamic value){
                setState(() {
                  SelectedClener = value;
                });
              },
              items: cleaners.map((val){
               return DropdownMenuItem(
                  value: val['Cleaner']['CleanerId'],
                  child: Text(val['Cleaner']['CleanerName'].toString()),
                );
              }).toList(),
            ),
          )
        ],
      );
  }
  SizedBox TaskCards(List<dynamic> snapshot,int index,String userId,DictionaryLoader tasksTranslation,double width){

    try{

      if(snapshot[index]['UserID'] == userId){
        return SizedBox(
          child: Card(
            color:  PrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: InkWell(
              child: Column(
                children: [
                  ListTile(
                    title: RichText(
                      text : TextSpan(
                          text: '${tasksTranslation.loadDictionary('label_address') + ' ' +snapshot[index]['Address']}',
                          style: DrawerTextStyle
                      ) ,
                    ),
                    subtitle: RichText(
                      text : TextSpan(
                        text: '${tasksTranslation.loadDictionary('label_date') + ' ' +snapshot[index]['Date']+ ' '+ tasksTranslation.loadDictionary('label_time') + ' ' +snapshot[index]['Time']}',
                        style: DrawerTextStyle,
                      ) ,
                    ),
                    trailing: Container(
                      width: width * 0.3,
                      color: Colors.white,
                      child: RaisedButton(
                        color: Colors.white,
                        child: changer ? Text(tasksTranslation.loadDictionary('label_cancel_v2'),style:changer ? MediumRedTextStyle: MediumGreenTextStyle): Text(tasksTranslation.loadDictionary('label_done'),style:changer ? MediumRedTextStyle: MediumGreenTextStyle),
                        onPressed: (){

                          showDialog(barrierDismissible: false,context: context, builder: (_)=>new AlertDialog(
                            title: Text(tasksTranslation.loadDictionary('label_conformation')),
                            content: changer ? Text(tasksTranslation.loadDictionary('label_question_v2')) : Text(tasksTranslation.loadDictionary('label_question')),
                            actions: [
                              FlatButton(
                                child: Text(tasksTranslation.loadDictionary('label_cancel')),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(tasksTranslation.loadDictionary('label_ok')),
                                onPressed:  () {
                                  updateTask(snapshot[index]['TaskID']).then((result){

                                    if(result == false){
                                      Navigator.of(context).pop();
                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(tasksTranslation.loadDictionary('label_failed')),
                                          content: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 68.0,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(tasksTranslation.loadDictionary('label_cancel')),
                                              onPressed:  () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    }else{
                                      Navigator.of(context).pop();
                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(tasksTranslation.loadDictionary('label_success')),
                                          content: Icon(
                                            Icons.check,
                                            color: PrimaryColor,
                                            size: 68.0,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(tasksTranslation.loadDictionary('label_return')),
                                              onPressed:  () {
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':snapshot[index]['UserID']});
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
                          ));
                        },
                      ),
                    ),
                  )
                ],
              ),
              onTap: (){
                Navigator.pushNamed(context, MapLocationRoute,arguments: {'userLang':userLang,'latitude':snapshot[index]['Latitude'],'longitude':snapshot[index]['Longitude'],'location':snapshot[index]['Address']});
              },
            ),
          ),
        ) ;
      }else{
        return SizedBox(
          height: 0.0,
          width: 0.0,
          child: Container(
            height: 0.0,
            width: 0.0,
          ),
        );
      }
    }catch(error, stacktrace){
     // ErrorLogger().log(error,stacktrace);
    }
  }
}