import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Domenitos/app.dart';
import 'package:Domenitos/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';

class CustomDrawer extends StatelessWidget{
  final String screen;
  CustomDrawer(this.screen);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyDrawerForm(screen);
  }
}

class MyDrawerForm extends StatefulWidget{
  final String screen;
  MyDrawerForm(this.screen);

  @override
  MyDrawerFormState createState(){
    return MyDrawerFormState(screen);
  }
}

class MyDrawerFormState extends State<MyDrawerForm>{
  final String screen;
  MyDrawerFormState(this.screen);

  //final storage = new FlutterSecureStorage();

  String userLang = '';
  String userType = '';
  String userId = '';
  String FirstName = '';
  String LastName = '';
  String email  ='';

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
    userType = await prefs.getString('userType');
    userLang = await prefs.getString('language');
    FirstName = await prefs.getString('firstName');
    LastName = await prefs.getString('lastName');
    email = await prefs.getString('username');
    userId = await prefs.getString('userID');
  }

  removeStorage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var drawerTranslation =DictionaryLoader(userLang,'/drawer');
    return Drawer(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context,int index){
                  print(userType);
                  print(userId);
                  if(userType == 'superadmin' || userType == 'admin'){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top:20.0,right: 2.0),
                          child: Text(FirstName + ' ' + LastName, style: DrawerTextStyle),
                        ),
                        Text(email,style: DrawerTextStyle,),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          color: screen == 'HomePageForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_home'), style: DrawerTextStyle,),
                              leading: new SvgPicture.asset(
                                'assets/images/48px_home.svg',
                                height: 25.0,
                                width: 25.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'CleanersForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_cleaners'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, CleanersRoute,arguments: {'userLang':userLang,'userType':userType});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'TasksForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_tasks'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.assignment,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':'null'});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'ApartmentsForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_apartments'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, ApartmentsRoute,arguments: {'userLang':userLang,'userType':userType,'ownerID':'null'});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'OwnersForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_owners'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, OwnersRoute,arguments: {'userLang':userLang,'userType':userType});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'SettingsForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_settings'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, SettingsRoute,arguments: {'userLang':userLang,'userType':userType,'userId':userId});
                              }
                          ),
                        ),
                        ListTile(
                          title: Text(drawerTranslation.loadDictionary('label_logout'), style: DrawerTextStyle),
                          leading: new SvgPicture.asset(
                            'assets/images/48px_leave.svg',
                            height: 25.0,
                            width: 25.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                          onTap: () {
                            removeStorage().then((result) {
                              Navigator.pushNamed(context, LoginRoute);
                            });
                          },
                        ),
                      ],
                    );
                  }else if(userType == 'cleaner'){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top:20.0,right: 2.0),
                          child: Text(FirstName + ' ' + LastName, style: DrawerTextStyle),
                        ),
                        Text(email,style: DrawerTextStyle,),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          color: screen == 'HomePageForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_home'), style: DrawerTextStyle,),
                              leading: new SvgPicture.asset(
                                'assets/images/48px_home.svg',
                                height: 25.0,
                                width: 25.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, HomePageRoute,arguments: {'userLang':userLang,'userType':userType});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'TasksForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_tasks'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.assignment,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                print(userType);
                                print(userLang);
                                print(userId);
                                Navigator.pushReplacementNamed(context, TasksRoute,arguments: {'userLang':userLang,'userType':userType,'userId':userId});
                              }
                          ),
                        ),
                        Container(
                          color: screen == 'SettingsForm' ? Color.fromRGBO(3,111, 138, 1) : PrimaryColor,
                          child: ListTile(
                              title: Text(drawerTranslation.loadDictionary('label_settings'), style: DrawerTextStyle,),
                              leading: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, SettingsRoute,arguments: {'userLang':userLang,'userType':userType,'userId':userId});
                              }
                          ),
                        ),
                        ListTile(
                          title: Text(drawerTranslation.loadDictionary('label_logout'), style: DrawerTextStyle),
                          leading: new SvgPicture.asset(
                            'assets/images/48px_leave.svg',
                            height: 25.0,
                            width: 25.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                          onTap: () {
                            removeStorage().then((result) {
                              Navigator.pushNamed(context, LoginRoute);
                            });
                          },
                        ),
                      ],
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

}