// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../services/pref_service.dart';
// import '../view/auth/login_view.dart';
// import '../view/home/home_view.dart';
//
// class MyAppRouter {
//   static String? userID;
//   static bool isLoggedIn = false;
//
//   static final router = GoRouter(
//     navigatorKey: Get.key,
//     initialLocation: '/login',
//     redirect: (context, state) {
//       final isLoggingIn = state.matchedLocation == '/login';
//
//       if (!isLoggedIn || userID == null) {
//         return isLoggingIn ? null : '/login';
//       }
//
//       if (isLoggingIn) {
//         return '/home';
//       }
//
//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: '/login',
//         builder: (_, __) => const LoginView(),
//       ),
//       GoRoute(
//         path: '/home',
//         builder: (_, __) => HomeView(userID: userID!),
//       ),
//     ],
//   );
// }