import 'package:firebase_messaging/firebase_messaging.dart';
Future<void>handleBackgroundMessage(RemoteMessage Message) async{
  print('Title: ${Message.notification?.title}');
  print('Body: ${Message.notification?.body}');
  print('Payload: ${Message.data}');
}

class FirebaseApi {
final _firebaeMessaging = FirebaseMessaging.instance;

Future<void> initNotifications()async{
  await _firebaeMessaging.requestPermission();
  final fCMToken = await _firebaeMessaging.getToken();
  print('Token:$fCMToken');
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}
}