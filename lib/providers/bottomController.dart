import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//
// class BottomBarProvider extends ChangeNotifier {
//   String _bottomBar = "main";
//   var bottomBarMain = Color(0xffff0066);
//   var bottomBarWrite = Colors.grey;
//   var bottomBarHistory = Colors.grey;
//   var bottomBarMyPage = Colors.grey;
//   String get bottomBar => _bottomBar;
//
//   tabMain() {
//     _bottomBar = "main";
//     notifyListeners();
//   }
//
//   tabMyPage() {
//     _bottomBar = "myPage";
//     notifyListeners();
//   }
// }

class BottomController extends GetxController {
  var _bottomBar = "main".obs;
  var bottomBarMain = Color(0xffff0066).obs;
  var bottomBarWrite = Colors.grey.obs;
  var bottomBarHistory = Colors.grey.obs;
  var bottomBarMyPage = Colors.grey.obs;
  String get bottomBar => _bottomBar.value;

  tabMain() {
    _bottomBar.value = "main";
  }

  tabMyPage() {
    _bottomBar.value = "myPage";
  }
}
