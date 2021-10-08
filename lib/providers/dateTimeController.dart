import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTimeController extends GetxController {

  var dateFirst = DateTime.now().obs;
  var dateSecond = DateTime.now().obs;
  var firstDateChecker = false.obs;
  var dateStringList = <String>[].obs;

  var hintTextFirst = '시작 날짜 선택'.obs;
  var hintTextSecond = '종료 날짜 선택'.obs;

  void storeDate(TextEditingController controller, DateTime first, DateTime second){
    String formatDate(DateTime date) => new DateFormat("yyyy-MM-dd").format(date);
    dateStringList.insert(0, formatDate(first));
    dateStringList.insert(1, formatDate(second));
    String date = "${dateStringList[0]} ~ ${dateStringList[1]}";
    controller.text = date;
  }
}