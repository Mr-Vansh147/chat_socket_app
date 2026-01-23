import 'package:get/get.dart';

class TabButtonController extends GetxController {
  int currentIndex = 0;

  void onChange(int index){
    currentIndex = index;
    update();
  }


}