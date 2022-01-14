
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:Domenitos/Classes/mapLoader.dart';
import 'package:Domenitos/Widgets/drawer.dart';
import 'package:Domenitos/app.dart';
import 'package:flutter/material.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../style.dart';

class ApartmentDetails extends StatelessWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> apartmentInfo;
  final String ownerName;
  final String ownerId;
  ApartmentDetails(this.userLang,this.userType,this.apartmentInfo,this.ownerName,this.ownerId);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ApartmentDetailsForm(userLang,userType,apartmentInfo,ownerName,ownerId);
  }
}

class ApartmentDetailsForm extends StatefulWidget{
  final String userLang;
  final String userType;
  final Map<String,dynamic> apartmentInfo;
  final String ownerName;
  final String ownerId;
  ApartmentDetailsForm(this.userLang,this.userType,this.apartmentInfo,this.ownerName,this.ownerId);

  ApartmentDetailsFormState createState(){
    return ApartmentDetailsFormState(userLang,userType,apartmentInfo,ownerName,ownerId);
  }
}

class ApartmentDetailsFormState extends State<ApartmentDetailsForm> {
  final String userLang;
  final String userType;
  final Map<String,dynamic> apartmentInfo;
  final String ownerName;
  final String ownerId;
  ApartmentDetailsFormState(this.userLang,this.userType,this.apartmentInfo,this.ownerName,this.ownerId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getPreviewImage(String latitude,String longitude, StateSetter settStatee) async{
    final staticMap = LocationHelper.generatePreviewImage(latitude: latitude,longitude: longitude);
    settStatee(() {
      previewImage = staticMap;
    });
  }

  int page_number = 0;
  PageController myPage = PageController(initialPage: 0);
  List<Marker> marker =[];
  String previewImage;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double height = MediaQuery
        .of(context)
        .size
        .height;

    var apartmentDetailsTranslation = DictionaryLoader(userLang,'/apartmentDetails');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(apartmentDetailsTranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      color: page_number == 0 ?  Color.fromRGBO(252 ,186,3, 1): Colors.white ,
                      size: 25.0,
                    ),
                    Text(apartmentDetailsTranslation.loadDictionary('label_basic_info'),style: TextStyle(
                      fontFamily: FontName,
                      fontWeight: page_number == 0 ? FontWeight.w600:  FontWeight.w400,
                      fontSize: SmallestTextSize,
                      color: page_number == 0 ?  Color.fromRGBO(252 ,186,3, 1):  Colors.white,
                    ),),
                    Container(
                      height: 1.5,
                      width: 65.0,
                      margin: EdgeInsets.only(top: 4.0),
                      color: page_number == 0 ? Colors.white:  PrimaryColor,
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    myPage.jumpToPage(0);
                    page_number = 0;
                  });
                },
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      color: page_number == 1 ?  Color.fromRGBO(252 ,186,3, 1): Colors.white ,
                      size: 25.0,
                    ),
                    Text(apartmentDetailsTranslation.loadDictionary('label_map'),style: TextStyle(
                      fontFamily: FontName,
                      fontWeight: page_number == 1 ? FontWeight.w600:  FontWeight.w400,
                      fontSize: SmallestTextSize,
                      color: page_number == 1 ?  Color.fromRGBO(252 ,186,3, 1):  Colors.white,
                    ),),
                    Container(
                      height: 1.5,
                      width: 65.0,
                      margin: EdgeInsets.only(top: 4.0),
                      color: page_number == 1 ? Colors.white:  PrimaryColor,
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    myPage.jumpToPage(1);
                    page_number = 1;
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: PageView(
        controller: myPage,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListView.builder(
            itemCount: 1,
            itemBuilder: (context, i){
              return Column(
                children: [
                  basicInfo(apartmentInfo,ownerName,apartmentDetailsTranslation),
                ],
              );
            },
          ),
          InkWell(
            child: Container(
              height: height  * 0.8,
              child: StatefulBuilder(
                builder: (BuildContext context,StateSetter settStatee){
                  marker.add(Marker(
                    markerId: MarkerId('1'),
                    draggable: false,
                    position: LatLng(double.parse(apartmentInfo['Latitude']),double.parse(apartmentInfo['Longitude'])),
                    infoWindow: InfoWindow(title: apartmentInfo['Address']),
                  ));
                    return ClipRRect(
                      borderRadius: BorderRadius
                          .circular(
                          20.0),
                      child: map(apartmentInfo,settStatee),
                    );
                  },
              ),
            ),
            onTap: (){
              if (kIsWeb) {
                // running on the web!
                print('web');
              } else {
                // NOT running on the web! You can check for additional platforms here.
                print('not web');
                Navigator.pushNamed(context, MapLocationRoute,arguments: {'userLang':userLang,'latitude':apartmentInfo['Latitude'],'longitude':apartmentInfo['Longitude'],'location':apartmentInfo['Address']});
              }
            },
          )
        ],
        onPageChanged: (page){
          setState(() {
            page_number = page;
          });
        },
      )
    );
  }
  Card basicInfo( Map<String,dynamic> apartmentInfo,String ownerName,DictionaryLoader apartmentDetailsTranslation ){

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
              child: Text(apartmentDetailsTranslation.loadDictionary('label_owner') + ' ' + ownerName,style: FormTextStyle,)
            ),
            Padding(
                padding: EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                child: Text(apartmentDetailsTranslation.loadDictionary('label_address') + ' ' + apartmentInfo['Address'],style: FormTextStyle,)
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(apartmentDetailsTranslation.loadDictionary('label_city') + ' ' + apartmentInfo['City'],style: FormTextStyle,),
                  Text(apartmentDetailsTranslation.loadDictionary('label_country') + ' ' + apartmentInfo['Country'],style: FormTextStyle,),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
              child:Text(apartmentDetailsTranslation.loadDictionary('label_squares') + ' ' + apartmentInfo['Squares'] + ' m2',style: FormTextStyle,),
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
              child:Text(apartmentDetailsTranslation.loadDictionary('label_description') + ' '+ apartmentInfo['Description'],style: FormTextStyle,)
            ),
          ],
        ),
      ),
    );
  }

  Image map(Map<String,dynamic> apartmentInfo, StateSetter settStatee){
    getPreviewImage(apartmentInfo['Latitude'],apartmentInfo['Longitude'], settStatee).then((result){

    });
    print(previewImage);
    return Image.network(previewImage);
  }
}