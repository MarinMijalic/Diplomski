import 'package:Domenitos/Classes/Error_Logger.dart';
import 'package:Domenitos/Services/call.dart';
import 'package:flutter/material.dart';
import 'package:Domenitos/app.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/Services/jsoncalls.dart';

class Cleaners extends StatelessWidget{
  final String userLang;
  final String userType;
  Cleaners(this.userLang,this.userType);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed() {
      Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
    }
    // TODO: implement build
    var cleanersTranslation = DictionaryLoader(userLang,'/cleaners');
    return WillPopScope(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: PrimaryColor,
          onPressed: (){
           Navigator.pushNamed(context, AddCleanerRoute,arguments: {'userLang':userLang,'userType':userType});
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Text(cleanersTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: PrimaryColor,
          ),
          child: CustomDrawer('CleanersForm'),
          //building a drawer on the left scroll of screen
        ),
        body: CleanersForm(userLang,userType),
      ),
      onWillPop: _onBackButtonPressed,
    );
  }
}

class CleanersForm extends StatefulWidget{
  final String userLang;
  final String userType;
  CleanersForm(this.userLang,this.userType);
  @override
  CleanersFormState createState() {
    // TODO: implement createState
    return CleanersFormState(userLang,userType);
  }
}

class CleanersFormState extends State<CleanersForm>{
  final String userLang;
  final String userType;
  CleanersFormState(this.userLang,this.userType);

  var future;
  final CallMessageEmailService service = CallMessageEmailService();
  @override
  void initState() {
    // TODO: implement initState
    future = getCleanerInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cleanersTranslation = DictionaryLoader(userLang,'/cleaners');
    // TODO: implement build
    return FutureBuilder(
      future:future,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data == null && snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: new CircularProgressIndicator(),
          );
        }else if(snapshot.data == null && snapshot.connectionState == ConnectionState.done){
          return Center(
            child: Text(cleanersTranslation.loadDictionary('label_msg_nothing'),style: BigGreenTextStyle,),
          );
        }else{
          int len = snapshot.data.length;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top:4.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                        return cleanerCards(snapshot.data,index,cleanersTranslation);
                      },
                      childCount: len
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
  Card cleanerCards(List<dynamic> snapshot,int index,DictionaryLoader cleanersTranslation){

    try{
      return Card(
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
                      text: '${snapshot[index]['FirstName'] + ' '+ snapshot[index]['LastName']}',
                      style: DrawerTextStyle
                  ) ,
                ),
                subtitle: RichText(
                  text : TextSpan(
                      text: '${snapshot[index]['Username']}',
                      style: DrawerTextStyle
                  ) ,
                ),
                leading:
                    Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.phone,
                            color: Colors.red,
                            size: 24.0,
                          ),
                          onTap: (){
                            service.call(snapshot[index]['UserPhone']);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.email,
                            color: Colors.red,
                            size: 24.0,
                          ),
                          onTap: (){
                            service.sendEmail(snapshot[index]['Username']);
                          },
                        ),
                      ],
                    ),
                trailing: Container(
                  width: 100,
                  color: Colors.white,
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text(cleanersTranslation.loadDictionary('label_edit'),style: MediumGreenTextStyle,),
                    onPressed: (){
                      // print(snapshot[index]);

                      Navigator.pushNamed(context, AddCleanerRoute,arguments: {'userLang':userLang,'userType':userType,'data' : snapshot[index]});
                    },
                  ),
                ),
              ),
          ]
          ),
          onTap: (){
            Navigator.pushNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':snapshot[index]['UserID']});
          },
        ),
      );
    }catch(error, stacktrace){
      //ErrorLogger().log(error,stacktrace);
    }

  }
}