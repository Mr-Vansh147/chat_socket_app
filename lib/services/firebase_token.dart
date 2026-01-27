import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static String? fcmToken;
  static Future<void> init() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmToken = await messaging.getToken();
    print("FCM TOKEN => $fcmToken");

    }

  }
