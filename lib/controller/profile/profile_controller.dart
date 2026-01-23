
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/update_profile_model.dart' hide Data;
import '../../model/user_profile_model.dart';
import '../../repository/profile_repo.dart';

class ProfileController extends GetxController {
  final ProfileRepo repository = ProfileRepo();

  bool isLoading = false;
  String errorMessage = '';
  UserProfileModel? userProfile;
  UpdateProfileModel? updateUser;
  Data? get user => userProfile?.data;
  final  TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();


  bool isVisiblity = true;


  void visibility() {
    isVisiblity = !isVisiblity;
    update();
  }

  void fetchUserProfile(String userId) {
    isLoading = true;
    errorMessage = '';
    update();

    repository
        .getProfile(id: userId)
        .then((result) {
          userProfile = result;
          firstNameController.text = user?.firstName ?? '';
          lastNameController.text = user?.lastName ?? '';
          emailController.text = user?.email ?? '';
          phoneController.text = user?.phoneNumber ?? '';
          profileImageController.text = user?.profileImage ?? '';
          countryCodeController.text = user?.countryCode ?? '';
          update();
        })
        .catchError((error) {
          errorMessage = error.toString();
        })
        .whenComplete(() {
          isLoading = false;
          update();
        });
  }

  void updateUserProfile(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String countryCode,
      String id,
      ) {
    isLoading = true;
    errorMessage = '';
    update();
    repository
        .updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      id: id,
    ).then((user) {
      updateUser = user;
      firstNameController.text = updateUser?.data?.firstName ?? '';
      lastNameController.text = updateUser?.data?.lastName ??  '';
      emailController.text = updateUser?.data?.email ?? '';
      phoneController.text = updateUser?.data?.phoneNumber ?? '';
      countryCodeController.text = updateUser?.data?.countryCode ?? '';

      Get.snackbar('Success', 'Profile Updated Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      update();
    }).catchError((error) {
      errorMessage = error.toString();
    }).whenComplete(() {
      isLoading = false;
      update();
    });
  }

}
