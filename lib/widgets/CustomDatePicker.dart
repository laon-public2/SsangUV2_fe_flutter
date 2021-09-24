import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:intl/intl.dart';

class CustomDate extends StatefulWidget {
  TextEditingController controller;
  CustomDate({required this.controller});
  @override
  _CustomDateState createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  String date = "";
  var dateItems = ['', ''];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextField(
              controller: widget.controller,
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
                hintText: "날짜 선택",
                hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
              ),
              onTap: () async {
                // 데이트레인지피커
                // final List<DateTime> selectedDate =
                //     await DateRangePicker.showDatePicker(
                //   locale: const Locale('ko', "KO"),
                //   context: context,
                //   initialFirstDate: new DateTime.now(),
                //   initialLastDate:
                //       (new DateTime.now()).add(new Duration(days: 7)),
                //   firstDate: new DateTime(2015),
                //   lastDate: new DateTime(2050),
                // );
                // if (selectedDate != null) {
                //   for (var i = 0; i < selectedDate.length; i++) {
                //     String formatDate(DateTime date) =>
                //         new DateFormat("yyyy-MM-dd").format(date);
                //     dateItems[i] = formatDate(selectedDate[i]);
                //   }
                //   setState(() {
                //     date = "${dateItems[0]} ~ ${dateItems[1]}";
                //     widget.controller.text = date;
                //   });
                // } else {
                //   setState(() {
                //     date = date;
                //   });
                // }
              },
            ),
          ),
        ],
      ),
    );
  }
}
