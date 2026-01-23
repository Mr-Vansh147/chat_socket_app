import 'package:chat_socket_practice/controller/group/group_profile_controller.dart';
import 'package:chat_socket_practice/controller/home/group_list_controller.dart';
import 'package:chat_socket_practice/controller/home/user_list_controller.dart';
import 'package:get/get.dart';
import '../controller/auth/auth_controller.dart';
import '../controller/chat/chat_controller.dart';
import '../controller/chat/image_controller.dart';
import '../controller/group/group_chat_controller.dart';
import '../controller/group/group_create_controller.dart';
import '../controller/group/select_users_controller.dart';
import '../controller/home/home_controller.dart';
import '../controller/home/tab_controller.dart';
import '../controller/profile/profile_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ChatController());
    Get.put(ProfileController());
    Get.put(UserListController());
    Get.put(GroupListController());
    Get.put(HomeController());
    Get.put(ImageController());
    Get.put(SelectUsersController());
    Get.put(GroupCreateController());
    Get.put(TabButtonController());
    Get.put(GroupChatController());
    Get.put(GroupProfileController());
  }
}