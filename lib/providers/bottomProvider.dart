import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBarProvider extends ChangeNotifier {
  String _bottomBar = "main";
  var bottomBarMain = Color(0xffff0066);
  var bottomBarWrite = Colors.grey;
  var bottomBarHistory = Colors.grey;
  var bottomBarMyPage = Colors.grey;
  String get bottomBar => _bottomBar;

  tabMain() {
    _bottomBar = "main";
    notifyListeners();
  }

  tabMyPage() {
    _bottomBar = "myPage";
    notifyListeners();
  }
}
