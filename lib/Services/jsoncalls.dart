import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Domenitos/Classes/Error_Logger.dart';

var url = Uri.parse('https://www.domenitos.com/mobile/handler.php');
//final storage = new FlutterSecureStorage();

Future <bool> LoginConformation(String username,String password) async {

  var body = '{ "DomenitosLoginRQ": { "authentication": {"password":"$password","username":"$username"} } }';
  var response = await http.post(url,body: body);
  var check = false;


  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);
    var mapResponse =  myMap["DomenitosLoginRS"]["success"];
    if(mapResponse == null){
      check = false;
    }else{
      check = true;
    }
  }
  return check;
}

Future<bool> getLoginInformation(String email, String password) async{
  var body =
      '{ "DomenitosLoginRQ": { "authentication": { "password": "$password", "username": "$email" } } }';
  bool check = false;
  var response = await http.post(url,body: body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(response.body);

  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);

    myMap.forEach((key, value){
      value.forEach((key2,value2){
        if(key2 == 'success'){
          check = true;
          var firstName = value2['firstName'];
          var lastName = value2['lastName'];
          var userType = value2['userType'];
          var language = value2['language'];
          var userPhone = value2['userPhone'];
          var password = value2['password'];
          var username = value2['username'];
          var session = value2['timestamp'];
          var companyId = value2['companyID'];
          var userID = value2['userID'];

         /* storage.write(key: 'firstName', value: firstName);
          storage.write(key: 'lastName', value: lastName);
          storage.write(key: 'userType', value: userType);
          storage.write(key: 'language', value: language);
          storage.write(key: 'userPhone', value: userPhone);
          storage.write(key: 'password', value: password);
          storage.write(key: 'username', value: username);
          storage.write(key: 'session', value: session);
          storage.write(key: 'companyID', value: companyId);
          storage.write(key: 'userID', value: userID);*/
          prefs.setString('firstName',firstName);
          prefs.setString('lastName',lastName);
          prefs.setString('userType',userType);
          prefs.setString('language',language);
          prefs.setString('userPhone',userPhone);
          prefs.setString('password',password);
          prefs.setString('username',username);
          prefs.setString('session',session);
          prefs.setString('companyID',companyId);
          prefs.setString('userID',userID);

        }else{
          check = false;
        }
      });

    });

    return check;
  }else if(response.statusCode == 500){
   // ErrorLogger().log2(response.statusCode.toString(), "EZMobileServiceLoginRQ");
  }

}
Future<dynamic> getOwnerInformation() async{

  String spremiste_email="";
  String spremiste_password= "";
  List<dynamic> list =  new List<dynamic>();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');


  var body =
      '{ "DomenitosOwnersRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" } } }';

  var response = await http.post(url,body: body);

  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosOwnersRS"]["success"];
    mapResponse.forEach((key,value){
      if(key =='timestamp'){
        return ;
      }
      list.add(value);

    });

    return list;
  }else if(response.statusCode == 500){
    //ErrorLogger().log2(response.statusCode.toString(), "DomenitosOwnersRQ");
  }
}
Future<dynamic> getCleanerInformation() async{

  String spremiste_email="";
  String spremiste_password= "";
  List<dynamic> list =  new List<dynamic>();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/

  var body =
      '{ "DomenitosCleanersRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" } } }';

  var response = await http.post(url,body: body);

  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosCleanersRS"]["success"];
    mapResponse.forEach((key,value){
      if(key =='timestamp'){
        return ;
      }
      list.add(value);

    });

    return list;
  }else if(response.statusCode == 500){
    //ErrorLogger().log2(response.statusCode.toString(), "DomenitosCleanersRQ");
  }
}

Future<bool> addOwner(String ownerName, String ownerLastName, String ownerEmail, String ownerPhone)async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/

  var body = '{ "DomenitosAddOwnerRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "ownerName":"$ownerName","ownerLastName": "$ownerLastName",'
      '"ownerEmail":"$ownerEmail","ownerPhone":"$ownerPhone"} } }';

  print(body);
  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosAddOwnerRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}
Future<bool> addTaskJson(String userId,String apartmentId,String desc,String date,String time) async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
 /* spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/

  var body = '{ "DomenitosAddTaskRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "userId":"$userId","apartmentId": "$apartmentId",'
      '"description":"$desc","date":"$date", "time":"$time"} } }';

  var response = await http.post(url,body: body);
  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosAddTaskRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }

}
Future<bool> addCleaner(String cleanerName, String cleanerLastName, String cleanerEmail, String cleanerPhone, String language,String password)async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
 /* spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/

  var body = '{ "DomenitosAddCleanerRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "cleanerName":"$cleanerName","cleanerLastName": "$cleanerLastName",'
      '"cleanerEmail":"$cleanerEmail","cleanerPhone":"$cleanerPhone", "userType":"cleaner", "language":"$language", "password":"$password"} } }';

 var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosAddCleanerRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}

Future<dynamic> getApartments ()async{
  String spremiste_email="";
  String spremiste_password= "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
 /* spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/
  List<dynamic> list = [];
  var body =
      '{ "DomenitosApartmentsRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" } } }';

  var response = await http.post(url,body: body);

  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosApartmentsRS"]["success"];
    mapResponse.forEach((key,value){
      if(key =='timestamp'){
        return ;
      }
      list.add(value);

    });
    return list;
  }else if(response.statusCode == 500){
   // ErrorLogger().log2(response.statusCode.toString(), "DomenitosApartmentsRQ");
  }
}

Future<dynamic> getTasks ()async{
  String spremiste_email="";
  String spremiste_password= "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
/*  spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/
  List<dynamic> list = [];
  var body =
      '{ "DomenitosTasksRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" } } }';

  var response = await http.post(url,body: body);

  if(response.statusCode == 200){
    Map<String,dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosTasksRS"]["success"];
    mapResponse.forEach((key,value){
      if(key =='timestamp'){
        return ;
      }
      list.add(value);

    });
    return list;
  }else if(response.statusCode == 500){
   // ErrorLogger().log2(response.statusCode.toString(), "DomenitosTasksRQ");
  }
}

Future<bool> updateTask(String taskId) async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
/*  spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/
  var body =
      '{ "DomenitosUpdateTaskRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" }, "request_data":{"taskId":"$taskId"} } }';
  print(body);
  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosUpdateTaskRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }

}
Future<bool> updateLanguage(String userId,String language) async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
 /* spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/
  var body =
      '{ "DomenitosUpdateLanguageRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" }, "request_data":{"userId":"$userId", "language":"$language"} } }';
  print(body);
  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosUpdateLanguageRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }

}
Future<bool> updatePassword(String userId,String password) async{
  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
 /* spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/
  var body =
      '{ "DomenitosUpdatePasswordRQ": { "authentication": { "password": "$spremiste_password", "username": "$spremiste_email" }, "request_data":{"userId":"$userId", "password":"$password"} } }';
  print(body);
  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosUpdatePasswordRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }

}

Future<bool> AddApartment(String description,String squares, String address, String  latitude,String longitude,String ownerid)async{

  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/

  var pom = address.split(',');

  var body = '{ "DomenitosAddApartmentRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "address":"${pom[0]}","zipcode": "${pom[1]}",'
      '"city":"${pom[2]}","country":"${pom[3]}", "squares":"$squares", "description":"$description","latitude":"$latitude","longitude":"$longitude","ownerId":"$ownerid"} } }';

  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosAddApartmentRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}


Future<bool> EditApartment(String description,String squares, String address,String zipcode,String city,String country, String  latitude,String longitude,String apartmantId, String ownerID)async{

  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/


  var body = '{ "DomenitosEditApartmantsRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "address":"$address","zipcode": "$zipcode",'
      '"city":"$city","country":"$country", "squares":"$squares", "description":"$description","latitude":"$latitude","longitude":"$longitude","ownerId":"$ownerID","apartmantId":"$apartmantId"} } }';


  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    print(myMap);
    var mapResponse = myMap["DomenitosEditApartmantsRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}
Future<bool> EditOwner(String ownerName,String ownerLastname, String OwnerPhone,String owmerEmail,String OwnerId,)async{

  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/


  var body = '{ "DomenitosEditOwnerRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "ownerName":"$ownerName","ownerEmail": "$owmerEmail",'
      '"ownerLastName":"$ownerLastname","ownerPhone":"$OwnerPhone", "ownerId":"$OwnerId"} } }';


  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    print(myMap);
    var mapResponse = myMap["DomenitosEditOwnerRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}
Future<bool> EditCleaners(String cleanerName,String cleanerLastName, String cleanerEmail,String cleanerPhone,String userType, String language,String userId)async{

  String spremiste_email="";
  String spremiste_password= "";
  bool check = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  spremiste_email = await prefs.getString('username');
  spremiste_password = await prefs.getString('password');
  /*spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');*/


  var body = '{"DomenitosEditCleanerRQ":{ "authentication": {"password":"$spremiste_password","username":"$spremiste_email"}, "request_data": { "cleanerName":"$cleanerName","cleanerLastName": "$cleanerLastName",'
      '"cleanerEmail":"$cleanerEmail","cleanerPhone":"$cleanerPhone", "userType":"$userType", "language":"$language", "UserID":"$userId"} } }';
print(body);

  var response = await http.post(url,body: body);

  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    print(myMap);
    var mapResponse = myMap["DomenitosEditCleanerRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }
}
/*Future<bool> ErrorLog(String platform, Map<String, dynamic> deviceParametars, Map<String, dynamic> applicationParameters, String error, String stacktrace) async{

  error = error.replaceAll('\n', '');
  error = error.replaceAll('"', '');
  stacktrace = stacktrace.replaceAll('\n', '');
  stacktrace = stacktrace.replaceAll('"', '');
  stacktrace = stacktrace.replaceAll('\t', ' ');
  String spremiste_email="";
  String spremiste_password= "";

  spremiste_email = await storage.read(key: 'username');
  spremiste_password = await storage.read(key: 'password');

  var body = '{ "DomenitosErrorLogRQ": { "authentication": {"password":"$spremiste_password","username":"$spremiste_email"},"request_data": { "platform":"$platform","build_type":"TEST","os_version": "${deviceParametars['versionRelase'].toString() + ' (SDK ' + deviceParametars['versionSdk'].toString()+ ')'}",'
      '"device":"${deviceParametars['manufacturer'] + ' ' + deviceParametars['model'].toString()}","app_version": "${applicationParameters['version'].toString()}",'
      '"device_time": "${DateTime.now().toString()}", "error_message": "$error","stacktrace": "$stacktrace"  }}}';
  print(body);
  var response = await http.post(url,body: body);
  bool check = false;
  if(response.statusCode == 200)  {
    Map<String, dynamic> myMap = json.decode(response.body);
    var mapResponse = myMap["DomenitosErrorLogRS"]["success"];
    mapResponse.forEach((k,v){
      if(k == '0'){
        if(v == 'Success'){
          check = true;
        }
      }
    });
    return check;
  }else{
    return check;
  }


}*/

Future<dynamic> getfalse() async{
  bool check = false;
  return check;
}