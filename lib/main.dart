import 'package:chat_socket_practice/services/firebase_token.dart';
import 'package:chat_socket_practice/services/pref_service.dart';
import 'package:chat_socket_practice/view/auth/login_view.dart';
import 'package:chat_socket_practice/view/home/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/root_binding.dart';
import 'firebase_options.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
 await FcmService.init();
 bool isLoggedIn = await PrefService.isLoggedIn();
 final String? userID = await PrefService.getUserId();

 print('isLoggedIn = $isLoggedIn');
 print('userID = $userID');
 runApp(MyApp(isLoggedIn: isLoggedIn,userID: userID,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userID;
  const MyApp({super.key, required this.isLoggedIn, this.userID});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: RootBinding(),
      home:
      isLoggedIn && userID != null
          ? HomeView(userID: userID!)
          : LoginView(),
    );
  }
}
