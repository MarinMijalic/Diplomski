import 'package:Domenitos/Classes/Error_Logger.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Screens/apartmentDetails.dart';
import 'package:Domenitos/Services/jsoncalls.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../style.dart';


class Apartments extends StatelessWidget{
  final String userLang;
  final String userType;
  final String ownerID;
  Apartments(this.userLang,this.userType,this.ownerID);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackButtonPressed() {
      Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
    }
    // TODO: implement build
    var apartmentsTranslation = DictionaryLoader(userLang,'/apartments');
    return WillPopScope(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: PrimaryColor,
          onPressed: (){
            Navigator.pushNamed(context, AddApartmentRoute,arguments: {'userLang':userLang,'userType':userType});
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Text(apartmentsTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: PrimaryColor,
          ),
          child: CustomDrawer('ApartmentsForm'),
          //building a drawer on the left scroll of screen
        ),
        body: ApartmentsForm(userLang,userType,ownerID),
      ),
      onWillPop: _onBackButtonPressed,
    );
  }
}

class ApartmentsForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final String ownerID;
  ApartmentsForm(this.userLang,this.userType,this.ownerID);
  @override
  ApartmentsFormState createState() {
    // TODO: implement createState
    return ApartmentsFormState(userLang,userType,ownerID);
  }
}

class ApartmentsFormState extends State<ApartmentsForm>{
  final String userLang;
  final String userType;
  final String ownerID;
  ApartmentsFormState(this.userLang,this.userType,this.ownerID);

  var future;
  List<dynamic> owners = [];
  String selectedOwner = '';
  @override
  void initState() {
    // TODO: implement initState
    future = getApartments();
    getOwnerInformation().then((result){
      result.forEach((value){
        value.forEach((key,value2){
          if(key == 'OwnersID'){
            String pomoc = value['OwnerName'] + ' ' + value['OwnerLastName'];
              owners.add({"Owner":{"OwnerId":value2,"OwnerName":pomoc}});
          }
        });
      });
      owners.forEach((value){
        if(value['Owner']['OwnerId'] == ownerID){
          setState(() {
            selectedOwner = value['Owner']['OwnerName'];
          });
        }
      });
      if(selectedOwner == ''){
        setState(() {
          selectedOwner = owners[0]['Owner']['OwnerName'];
        });
      }
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
    var apartmentsTranslation = DictionaryLoader(userLang,'/apartments');
    return FutureBuilder(
      future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null && snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: new CircularProgressIndicator(),
            );
          }else if(snapshot.data == null && snapshot.connectionState == ConnectionState.done){
            return Center(
              child: Text(apartmentsTranslation.loadDictionary('label_msg_nothing'),style: BigGreenTextStyle,),
            );
          }else{
            int len = snapshot.data.length;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(4.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index){
                              return ownerss(width,apartmentsTranslation);
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
                              String ownerid = '';
                              owners.forEach((value){
                                if(value['Owner']['OwnerName'] == selectedOwner){
                                  ownerid = value['Owner']['OwnerId'];
                                }
                              });
                          return apartmentsCards(snapshot.data,index,ownerid,apartmentsTranslation);
                        },
                        childCount: len
                    ),
                  ),
                ),
              ],
            );
          }
    });
  }
  Column ownerss(double width, DictionaryLoader apartmentsTranslation ){
    try{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 12.0)),
          Text(apartmentsTranslation.loadDictionary('label_owner_filter'),style: FormTextStyle,),
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
            child: DropdownButton<dynamic>(
                isDense: true,
                hint: Text(apartmentsTranslation.loadDictionary('label_select_owner')),
                value: selectedOwner,
                onChanged: (dynamic value){
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
        ]
      );
    }catch(error, stacktrace){
    //  ErrorLogger().log(error,stacktrace);
    }
  }
  SizedBox apartmentsCards(List<dynamic> snapshot,int index,String ownerid,DictionaryLoader apartmentsTranslation){
    try{
      if(snapshot[index]['OwnerID'] == ownerid){
        print(snapshot[index]);
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
                          text: '${apartmentsTranslation.loadDictionary('label_address') + ' ' +snapshot[index]['Address']}',
                          style: DrawerTextStyle
                      ) ,
                    ),
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 22,
                    ),
                    trailing: Container(
                      width: 100,
                      color: Colors.white,
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text(apartmentsTranslation.loadDictionary('label_edit'),style: MediumGreenTextStyle,),
                        onPressed: (){
                          // print(snapshot[index]);
                          print(selectedOwner);
                          Navigator.pushNamed(context, AddApartmentRoute,arguments: {'userLang':userLang,'userType':userType,'data':snapshot[index]});
                        },
                      ),
                    ),
                  )
                ],
              ),
              onTap: (){
                print(snapshot[index]);
                print(selectedOwner);
                print(ownerid);
                Navigator.pushNamed(context, ApartmentDetailsRoute,arguments: {'userLang':userLang,'userType':userType,'apartmentInfo':snapshot[index],'ownerName':selectedOwner,'ownerId':ownerid});
              },
            ),
          ),
        );
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