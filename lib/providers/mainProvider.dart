import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  void notify(){
    notifyListeners();
  }
}
