import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Domenitos/Classes/dictionaryLoader.dart';
import 'package:Domenitos/style.dart';


class MapLocation extends StatefulWidget{
  final String user_lang;
  final String latitude;
  final String longitude;
  final String location;
  MapLocation(this.user_lang,this.latitude,this.longitude,this.location);
  MapLocationState createState(){
    return MapLocationState(user_lang,latitude,longitude,location);
  }
}

class MapLocationState extends State<MapLocation>{
  final String user_lang;
  final String latitude;
  final String longitude;
  final String location;


  MapLocationState(this.user_lang,this.latitude,this.longitude,this.location);
  List<Marker> _marker =[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.add(Marker(
      markerId: MarkerId('1'),
      draggable: false,
      position: LatLng(double.parse(latitude),double.parse(longitude)),
      infoWindow: InfoWindow(title: location,snippet: ''),
    ));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var maptranslation = DictionaryLoader(user_lang,'/mapLoader');
    return Scaffold(
      appBar: AppBar(
        title: Text(maptranslation.loadDictionary('label_title'),style: AppBarTextStyle,),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(double.parse(latitude),double.parse(longitude)),zoom: 15),
        markers: Set.from(_marker),
        mapType: MapType.normal,
        compassEnabled: true,
      ),
    );
  }
}