const GOOGLE_API_KEY='';//not on git


class LocationHelper{
  static String generatePreviewImage({String latitude,String longitude}){
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x400&maptype=roadmap&markers=color:red%7C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}