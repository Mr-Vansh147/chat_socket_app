
import 'package:get/get.dart';

import '../../model/group_members_model.dart';
import '../../repository/group_repo.dart';

class GroupProfileController extends GetxController {
 final GroupRepo repository = GroupRepo();

  bool isLoading = false;
  String errorMessage = '';
 GroupMembersModel? groupProfile;

  void fetchGroupProfile(String id) {
    isLoading = true;
    errorMessage = '';
    update();

    repository
        .groupMembers(groupId: id)
        .then((result) {
      groupProfile = result;
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

}
