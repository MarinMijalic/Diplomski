/*import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:Domenitos/Services/jsoncalls.dart';


class ErrorLogger {

  Map<String, dynamic> _deviceParameters = Map();
  Map<String, dynamic> _applicationParameters = Map();
  String platform = '';

  void logError(FlutterErrorDetails details) async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      platform ='android';
      deviceInfo.androidInfo.then((androidInfo) {
        _loadAndroidParameters(androidInfo);
        _loadApplicationInfo();
        _sendToServer(details.exceptionAsString(), details.stack.toString());
      });
    } else {
      platform ='ios';
      deviceInfo.iosInfo.then((iosInfo) async{
        _loadIosParameters(iosInfo);
        await _loadApplicationInfo();
        _sendToServer(details.exceptionAsString(), details.stack.toString());
      });
    }
  }
  void log2(String status_code, String body)async{

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      platform ='android';
      deviceInfo.androidInfo.then((androidInfo) async{
        _loadAndroidParameters(androidInfo);
        await _loadApplicationInfo();
        _sendToServer(status_code.toString(), body.toString());
      });
    } else {
      platform ='ios';
      deviceInfo.iosInfo.then((iosInfo) async{
        _loadIosParameters(iosInfo);
        await  _loadApplicationInfo();
        _sendToServer(status_code.toString(), body.toString());
      });
    }
  }
  void log(Object data, StackTrace stackTrace) async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      platform ='android';
      deviceInfo.androidInfo.then((androidInfo) async{
        _loadAndroidParameters(androidInfo);
        await _loadApplicationInfo();
        _sendToServer(data.toString(), stackTrace.toString());
      });
    } else {
      platform ='ios';
      deviceInfo.iosInfo.then((iosInfo) async{
        _loadIosParameters(iosInfo);
        await  _loadApplicationInfo();
        _sendToServer(data.toString(), stackTrace.toString());
      });
    }

  }

  void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    _deviceParameters["manufacturer"] = androidDeviceInfo.manufacturer;
    _deviceParameters["model"] = androidDeviceInfo.model;
    _deviceParameters["versionRelase"] = androidDeviceInfo.version.release;
    _deviceParameters["versionSdk"] = androidDeviceInfo.version.sdkInt;
  }

  void _loadIosParameters(IosDeviceInfo iosInfo) {
    _deviceParameters["model"] = iosInfo.model;
    _deviceParameters["isPsychicalDevice"] = iosInfo.isPhysicalDevice;
    _deviceParameters["name"] = iosInfo.name;
    _deviceParameters["identifierForVendor"] = iosInfo.identifierForVendor;
    _deviceParameters["localizedModel"] = iosInfo.localizedModel;
    _deviceParameters["systemName"] = iosInfo.systemName;
    _deviceParameters["utsnameVersion"] = iosInfo.utsname.version;
    _deviceParameters["utsnameRelease"] = iosInfo.utsname.release;
    _deviceParameters["utsnameMachine"] = iosInfo.utsname.machine;
    _deviceParameters["utsnameNodename"] = iosInfo.utsname.nodename;
    _deviceParameters["utsnameSysname"] = iosInfo.utsname.sysname;
  }

  void _loadApplicationInfo() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _applicationParameters["version"] = packageInfo.version;
      _applicationParameters["appName"] = packageInfo.appName;
      _applicationParameters["buildNumber"] = packageInfo.buildNumber;
      _applicationParameters["packageName"] = packageInfo.packageName;
    });
  }

  void _sendToServer(String error, String stacktrace) async {

    ErrorLog(platform,_deviceParameters,_applicationParameters,error.toString(),stacktrace.toString()).then((res){
      if(res == true){
        print('True $res');
      }else{
        print('Errror log greska');
      }
    });
  }
}*/