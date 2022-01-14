import 'package:flutter/material.dart';
import 'package:Domenitos/Screens/login.dart';
import 'package:Domenitos/style.dart';
import 'package:Domenitos/Screens/homepage.dart';
import 'package:Domenitos/Screens/owners.dart';
import 'package:Domenitos/Screens/addOwner.dart';
import 'package:Domenitos/Screens/cleaners.dart';
import 'package:Domenitos/Screens/addCleaners.dart';
import 'package:Domenitos/Screens/apartments.dart';
import 'package:Domenitos/Screens/addApartments.dart';
import 'package:Domenitos/Screens/apartmentDetails.dart';
import 'package:Domenitos/Screens/mapLocation.dart';
import 'package:Domenitos/Screens/tasks.dart';
import 'package:Domenitos/Screens/addTask.dart';
import 'package:Domenitos/Screens/settings.dart';

const LoginRoute ='/';
const HomePageRoute = '/home';
const OwnersRoute = '/owners';
const AddOwnerRoute = '/addOwners';
const CleanersRoute ='/cleaners';
const AddCleanerRoute ='/addCleaners';
const ApartmentsRoute = '/apartments';
const AddApartmentRoute ='/addApartment';
const ApartmentDetailsRoute = '/appartmentDetails';
const MapLocationRoute = '/mapLocation';
const TasksRoute = '/tasks';
const AddTaskRoute = '/addTask';
const SettingsRoute = '/setting';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginRoute,
      debugShowCheckedModeBanner: false,
      onGenerateRoute:  routes(),
      title: 'Domenitos',
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.grey.shade50,
          labelColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black)
        ),
        backgroundColor: Colors.white,
        primaryColor: PrimaryColor,
        bottomAppBarColor: PrimaryColor,
        canvasColor: Colors.white,
      ),
    );
  }

  RouteFactory routes(){
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name){
        case LoginRoute:
          screen = Login();
          break;
        case HomePageRoute:
          screen = HomePage(arguments['userLang'],arguments['userType']);
          break;
        case OwnersRoute:
          screen = Owners(arguments['userLang'],arguments['userType']);
          break;
        case AddOwnerRoute:
          screen = AddOwner(arguments['userLang'],arguments['userType'],arguments['data']);
          break;
        case CleanersRoute:
          screen = Cleaners(arguments['userLang'],arguments['userType']);
          break;
        case AddCleanerRoute:
          screen = AddCleaner(arguments['userLang'],arguments['userType'],arguments['data']);
          break;
        case ApartmentsRoute:
          screen = Apartments(arguments['userLang'],arguments['userType'],arguments['ownerID']);
          break;
        case AddApartmentRoute:
          screen = AddApartments(arguments['userLang'],arguments['userType'],arguments['data']);
          break;
        case ApartmentDetailsRoute:
          screen = ApartmentDetails(arguments['userLang'],arguments['userType'],arguments['apartmentInfo'],arguments['ownerName'],arguments['ownerId']);
          break;
        case MapLocationRoute:
          screen = MapLocation(arguments['userLang'],arguments['latitude'],arguments['longitude'],arguments['location']);
          break;
        case TasksRoute:
          screen = Tasks(arguments['userLang'],arguments['userType'],arguments['userId']);
          break;
        case AddTaskRoute:
          screen = AddTask(arguments['userLang'],arguments['userType']);
          break;
        case SettingsRoute:
          screen = Settings(arguments['userLang'],arguments['userType'],arguments['userId']);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
