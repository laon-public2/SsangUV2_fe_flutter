import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:intl/intl.dart';
import 'package:share_product_v2/providers/dateTimeController.dart';

class CustomDate extends StatelessWidget {
  TextEditingController controller;

  CustomDate({required this.controller});

  DateTimeController dateTimeController = Get.put(DateTimeController());

  String date = "";
  var dateItems = ['', ''];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xffdddddd),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffaaaaaa),
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: dateTimeController.hintTextFirst.value,
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
                  ),
                  onTap: () async {
                    dateTimeController.firstDateChecker.value = false;
                    dateTimeController.dateSecond.value = DateTime.now();
                    dateTimeController.hintTextSecond.value = '종료 날짜 선택';
                    await DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 14), onChanged: (date) {
                    }, onConfirm: (date) async {
                      dateTimeController.dateFirst.value = date;
                      String formatDate(DateTime date) => new DateFormat("yyyy-MM-dd").format(date);
                      dateTimeController.hintTextFirst.value = formatDate(date);
                     dateTimeController.firstDateChecker.value = true;
                    }, currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: dateTimeController.firstDateChecker.value ? Colors.white : Colors.grey[300],
            border: Border.all(
              color: Color(0xffdddddd),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextField(
                  enabled: dateTimeController.firstDateChecker.value ? true : false,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffaaaaaa),
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: dateTimeController.hintTextSecond.value,
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
                  ),
                  onTap: () async {
                    await DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: dateTimeController.dateFirst.value,
                        maxTime: DateTime(
                            dateTimeController.dateFirst.value.year,
                            dateTimeController.dateFirst.value.month,
                            dateTimeController.dateFirst.value.day + 14), onChanged: (date) {
                        }, onConfirm: (date) async {
                          dateTimeController.dateSecond.value = date;
                          String formatDate(DateTime date) => new DateFormat("yyyy-MM-dd").format(date);
                          dateTimeController.hintTextSecond.value = formatDate(date);
                          dateTimeController.storeDate(
                              controller,
                              dateTimeController.dateFirst.value,
                              dateTimeController.dateSecond.value);
                        }, currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                ),
                // ],
                // ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
