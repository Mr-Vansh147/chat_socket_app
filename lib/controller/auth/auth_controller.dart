import 'dart:io';
import 'package:chat_socket_practice/controller/home/home_controller.dart';
import 'package:chat_socket_practice/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mime/mime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/exception_helper.dart';
import '../../repository/auth_repo.dart';
import '../../services/image_picker_service.dart';
import '../../services/pref_service.dart';
import '../../view/home/home_view.dart';
import '../chat/chat_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final AuthRepo authRepo = AuthRepo();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  File? selectedImage;

  bool isVisiblity = true;
  bool isSignupSubmit = false;
  bool isLoginSubmit = false;
  String? userId;
  String? userFirstName;
  String? userProfileImage;

  @override
  void onInit() {
    super.onInit();
    restoreUser();
  }

  Future<void> restoreUser() async {
    final isLoggedIn = await PrefService.isLoggedIn();
    if (isLoggedIn) {
      userId = await PrefService.getUserId();
      userFirstName = await PrefService.getFirstName();
      userProfileImage = await PrefService.getProfileImage();

      update();
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String password,
    required File? profileImage,
  }) async {
    if (profileImage != null) {
      final mimeType = lookupMimeType(profileImage.path);
      const allowedTypes = [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/webp',
      ];

      if (mimeType == null || !allowedTypes.contains(mimeType)) {
        Get.snackbar(
          "Invalid Image",
          "Only JPG, PNG, JPEG, WEBP images are allowed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    try {
      isSignupSubmit = true;
      update();

      print("firstName: $firstName");
      print("lastName: $lastName");
      print("email: $email");
      print("countryCode: $countryCode");
      print("phoneNumber: $phoneNumber");
      print("password: $password");
      print("profileImage: ${profileImage?.path}");

      final response = await authRepo.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        password: password,
        profileImage: profileImage,
      );

      print("status: ${response.status}");
      print("success: ${response.success}");
      print("message: ${response.message}");

      if (response.success == true) {
        Get.snackbar(
          "Success",
          response.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          Get.to(() => LoginView());
        });
      } else if (response.status == 400) {
        Get.snackbar(
          "Bad Request",
          response.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSignupSubmit = false;
      update();
    }
  }

  Future<void> login() async {
    try {
      isLoginSubmit = true;
      update();

      final response = await authRepo.loginUser(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      print("LOGIN RESPONSE: ${response.message}");

      if (response.success == true) {
        userId = response.data!.id.toString();
        userFirstName = response.data!.firstName.toString();
        userProfileImage = response.data!.profileImage.toString();

        await PrefService.saveLogin(isLoggedIn: true, userId: userId!);
        print('LOGIN SAVED TO PREFS');

        await PrefService.saveUserMeta(
          firstName: userFirstName ?? '',
          profileImage: userProfileImage ?? '',
        );

        Get.snackbar(
          "Success",
          response.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => HomeView(userID: userId!));
      } else {
        Get.snackbar(
          "Login Failed",
          response.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      showError("Login Failed", e);
    } finally {
      isLoginSubmit = false;
      update();
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = googleUser.authentication;

      final idToken = auth.idToken;
      if (idToken == null) {
        print("Google ID token is null");
        return null;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        userId = userCredential.user!.uid;
        userFirstName = userCredential.user!.displayName;
        userProfileImage = userCredential.user!.photoURL;

        await PrefService.saveLogin(isLoggedIn: true, userId: userId!);
        print('Google LOGIN SAVED TO PREFS');
        print('Google USER ID: $userId');
        print('Google USER FIRST NAME: $userFirstName');

        await PrefService.saveUserMeta(
          firstName: userFirstName ?? '',
          profileImage: userProfileImage ?? '',
        );
        Get.snackbar(
          "Success",
          "Google sign‑in successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.find<ChatController>().initSocket();
        Get.offAll(() => HomeView(userID: userId!));
      }
      return userCredential.user;
    } catch (e) {
      print("Google sign‑in error: $e");
      return null;
    }
  }

  void visibility() {
    isVisiblity = !isVisiblity;
    update();
  }

  void pickImage() async {
    final ImagePickerService imagePickerService = ImagePickerService();
    final File? image = await imagePickerService.pickImageFromCamera();

    if (image != null) {
      selectedImage = image;
      update();
    }
  }

  void clearField() async {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    countryCodeController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    loginEmailController.clear();
    loginPasswordController.clear();
    selectedImage = null;

    update();
  }

  String normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    // Emulator only
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  void logOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    clearField();
    Get.find<HomeController>().onLogout();
    Get.find<ChatController>().socketService.disconnect();
    Get.find<ChatController>().onLogout();
    await PrefService.logout();
    Get.offAll(
      () => LoginView(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }
}
