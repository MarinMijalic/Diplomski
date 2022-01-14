import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Domenitos/Classes/Error_Logger.dart';
import 'app.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  /*FlutterError.onError = (FlutterErrorDetails details) async{
    new ErrorLogger().logError((details));
  };*/
  runZoned<Future<void>>(()async{
    runApp(App());
  });/*onError: (error,stackTrace){
    new ErrorLogger().log(error, stackTrace);
  });*/

} //function which starts the app and starts error handler
