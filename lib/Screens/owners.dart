import 'package:Domenitos/Classes/Error_Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/Services/call.dart';
import 'package:Domenitos/app.dart';


class Owners extends StatelessWidget{
  final String userLang;
  final String userType;
  Owners(this.userLang,this.userType);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed() {
      Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
    }
    // TODO: implement build
    var homePageTranslation = DictionaryLoader(userLang,'/owners');
    return WillPopScope(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: PrimaryColor,
          onPressed: (){
            Navigator.pushNamed(context, AddOwnerRoute,arguments: {'userLang':userLang,'userType':userType});
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Text(homePageTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: PrimaryColor,
          ),
          child: CustomDrawer('OwnersForm'),
          //building a drawer on the left scroll of screen
        ),
        body: OwnersForm(userLang,userType),
      ),
      onWillPop: _onBackButtonPressed,
    );
  }
}

class OwnersForm extends StatefulWidget{
  final String userLang;
  final String userType;
  OwnersForm(this.userLang,this.userType);
  @override
  OwnersFormState createState() {
    // TODO: implement createState
    return OwnersFormState(userLang,userType);
  }
}

class OwnersFormState extends State<OwnersForm>{
  final String userLang;
  final String userType;
  OwnersFormState(this.userLang,this.userType);

  var future;
  final CallMessageEmailService service = CallMessageEmailService();
  @override
  void initState() {
    // TODO: implement initState
    future = getOwnerInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var homePageTranslation = DictionaryLoader(userLang,'/owners');

    return FutureBuilder(
        future:future,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null && snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: new CircularProgressIndicator(),
            );
          }else if(snapshot.data == null && snapshot.connectionState == ConnectionState.done){
            return Center(
              child: Text(homePageTranslation.loadDictionary('label_msg_nothing'),style: BigGreenTextStyle,),
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
                              return ownerCards(snapshot.data,index);
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

  Card ownerCards(List<dynamic> snapshot,int index){
    print(snapshot[index]);
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
                      text: '${snapshot[index]['OwnerName'] + ' '+ snapshot[index]['OwnerLastName']}',
                      style: DrawerTextStyle
                  ) ,
                ),
                subtitle: RichText(
                  text : TextSpan(
                      text: '${snapshot[index]['OwnerEmail']}',
                      style: DrawerTextStyle
                  ) ,
                ),
                leading: Column(
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.phone,
                        color: Colors.red,
                        size: 24.0,
                      ),
                      onTap: (){
                        service.call(snapshot[index]['OwnerPhone']);
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
                        service.sendEmail(snapshot[index]['OwnerEmail']);
                      },
                    ),
                  ],
                ),
                trailing: Container(
                  width: 100,
                  color: Colors.white,
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text('Edit',style: MediumGreenTextStyle,),
                    onPressed: (){
                      // print(snapshot[index]);
                      Navigator.pushNamed(context, AddOwnerRoute,arguments: {'userLang':userLang,'userType':userType,'data': snapshot[index]});
                    },
                  ),
                ),
              )
            ],
          ),
          onTap: (){
            print(snapshot[index]['OwnersID']);
            Navigator.pushNamed(context, ApartmentsRoute,arguments: {'userLang':userLang,'userType':userType,'ownerID':'${snapshot[index]['OwnersID']}'});
          },
        ),
      );
    }catch(error, stacktrace){
     // ErrorLogger().log(error,stacktrace);
    }

  }
}