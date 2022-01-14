import 'package:url_launcher/url_launcher.dart';

class CallMessageEmailService{

  void call(String number) => launch('tel://$number');

  void sendEmail(String email) => launch('mailto:$email');

  void sendSMS(String number) => launch('sms:$number');

}