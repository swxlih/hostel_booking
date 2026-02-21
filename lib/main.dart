import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Notifications/firebase_api.dart';
import 'package:hostel_booking/Splash/splashpage.dart';
import 'package:hostel_booking/vendor/bottomnav.dart';
final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await  FirebaseApi().initNotifications();

  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(448,997),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: Splashpage(),
        );
      },
    );
  }
}