import 'package:Domenitos/Classes/Dictionary.dart';

class DictionaryLoader {

  final String defaultLanguage = 'en';
  String language = 'en';
  var list;

  DictionaryLoader(language,screen){
    this.language = language;

    if(screen == '/login'){
      list = Dictionary().LoginTranslation;
    }else if(screen == '/drawer'){
      list = Dictionary().DrawerTranslation;
    }else if(screen  == '/homePage'){
      list = Dictionary().HomePageTranslation;
    }else if(screen =='/owners'){
      list = Dictionary().OwnersTranslation;
    }else if(screen =='/addowner'){
      list = Dictionary().AddOwnersTranslation;
    }else if(screen == '/cleaners'){
      list = Dictionary().CleanersTranslation;
    }else if(screen == '/addcleaner'){
      list = Dictionary().AddCleanersTranslation;
    }else if(screen == '/apartments'){
      list = Dictionary().ApartmentsTranslation;
    }else if(screen == '/addapartment'){
      list = Dictionary().AddApartmentsTranslation;
    }else if (screen == '/apartmentDetails'){
      list = Dictionary().ApartmentDetails;
    }else if(screen == '/mapLoader'){
      list =Dictionary().MapTranslation;
    }else if(screen == '/tasks'){
      list =Dictionary().TasksTranslation;
    }else if(screen == '/addTask'){
      list =Dictionary().AddTaskTranslation;
    }else if(screen == '/settings'){
      list =Dictionary().SettingsTranslation;
    }

  }

  String loadDictionary (String listlabel){
    var returnString = '';
    list.forEach((key){
      key.forEach((key2,value){
        if(key2 == listlabel){
          if(value[0][language] == null){
            returnString = value[0][defaultLanguage];
          }else{
            returnString = value[0][language];
          }
        }
      });
    });
    if(returnString == ''){
      returnString = listlabel;
      return returnString;
    }else{
      return returnString;
    }
  }

}