import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/Screens/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Widgets/drawer.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Domenitos/app.dart';



class HomePage extends StatelessWidget {
  final String userLang;
  final String userType;
  HomePage(this.userLang,this.userType);
  Future<bool> _onBackButtonPressed() {
    //function which if back button is pressed exits the app
    SystemNavigator.pop();
  }

  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var homePageTranslation = DictionaryLoader(userLang,'/homePage');
    return WillPopScope(
        child: Scaffold(
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
            child: CustomDrawer('HomePageForm'),
            //building a drawer on the left scroll of screen
          ),
          body: HomePageForm(userLang,userType),
        ),
        onWillPop: _onBackButtonPressed,
    );
  }
}

class HomePageForm extends StatefulWidget{
  final String userLang;
  final String userType;
  HomePageForm(this.userLang,this.userType);
  @override
  HomePageFormState createState() {
    // TODO: implement createState
    return HomePageFormState(userLang,userType);
  }
}

class HomePageFormState extends State<HomePageForm> {
  final String userLang;
  final String userType;
  HomePageFormState(this.userLang,this.userType);

  //final storage = new FlutterSecureStorage();
  double iconSize;
  double axisSpacing;
  int crossAxisCount;
  TextStyle gridText;
  String userId = '';
  @override
  void initState() {
    // TODO: implement initState
    readUserType().then((result){
      if(userType.isNotEmpty){
        setState(() {
        });
      }
    });
    super.initState();
  }
  readUserType() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = await prefs.getString('userID');
   // userId = await storage.read(key: 'userID');
  }
  removeStorage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
   // await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var homePageTranslation = DictionaryLoader(userLang,'/homePage');
    double width = MediaQuery
        .of(context)
        .size
        .width;
    if(width > 1200 ){
      iconSize = 220.0;
      axisSpacing = 44.0;
      gridText = GridTabletTextStyle;
      crossAxisCount =4;
    }else if(width <= 575){
      iconSize = 80.0;
      axisSpacing = 12.0;
      gridText = GridTextStyle;
      crossAxisCount = 2;
    }else if (width >= 576){
      iconSize = 140.0;
      axisSpacing = 24.0;
      gridText = GridTextStyle;
      crossAxisCount = 3;
    }
    print(MediaQuery.of(context).size.width);

    if(userType == 'superadmin' || userType == 'admin'){
      return Container(
        width: width,
        child: Align(
          alignment: Alignment.center,
          child: GridView.builder(
              itemCount: 5,
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: axisSpacing,
                mainAxisSpacing: axisSpacing,
              ),
              itemBuilder: (context, i){
                return buildGridAdmin(i,gridText,homePageTranslation);
              }
          ),
        ),
      );
    }else{
      return Container(
        width: width,
        child: Align(
          alignment: Alignment.center,
          child: GridView.builder(
              itemCount: 2,
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: axisSpacing,
                mainAxisSpacing: axisSpacing,
              ),
              itemBuilder: (context, i){
                return buildGridCleaner(i,gridText,homePageTranslation);
              }
          ),
        ),
      );
    }

  }
  Card buildGridAdmin(int i, TextStyle GridStyle,DictionaryLoader homePageTranslation){

    if(i == 0){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: iconSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_owners'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            Navigator.pushReplacementNamed(context, OwnersRoute,arguments: {'userLang':userLang,'userType':userType});
          },
        ),
      );
    }else if(i == 1){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                color: Colors.white,
                size: iconSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_apartments'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            print(userType);
            print(userLang);
            Navigator.pushReplacementNamed(context, ApartmentsRoute,arguments: {'userLang':userLang,'userType':userType,'ownerID':'null'});
          },
        ),
      );
    }else if(i==2){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_pin,
                color: Colors.white,
                size: iconSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_cleaners'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            print(userType);
            print(userLang);
            Navigator.pushReplacementNamed(context, CleanersRoute,arguments: {'userLang':userLang,'userType':userType});
          },
        ),
      );
    }else if(i==3){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment,
                color: Colors.white,
                size: iconSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_tasks'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            print(userType);
            print(userLang);
            Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':'null'});
          },
        ),
      );
    }else if(i==4){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SvgPicture.asset(
                'assets/images/48px_leave.svg',
                height: iconSize,
                width: iconSize,
                allowDrawingOutsideViewBox: true,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_logout'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            removeStorage().then((result){
              Navigator.pushNamed(context, LoginRoute);
            });
          },
        ),
      );
    }
  }
  Card buildGridCleaner(int i, TextStyle GridStyle,DictionaryLoader homePageTranslation){

    if(i==0){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment,
                color: Colors.white,
                size: iconSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_tasks'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            print(userType);
            print(userLang);
            print(userId);
            Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':userId});
          },
        ),
      );
    }else if(i==1){
      return Card(
        margin: const EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: PrimaryColor,
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SvgPicture.asset(
                'assets/images/48px_leave.svg',
                height: iconSize,
                width: iconSize,
                allowDrawingOutsideViewBox: true,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text(homePageTranslation.loadDictionary('label_logout'),style: GridStyle,),
              ),
            ],
          ),
          onTap: (){
            removeStorage().then((result){
              Navigator.pushNamed(context, LoginRoute);
            });
          },
        ),
      );
    }
  }
}