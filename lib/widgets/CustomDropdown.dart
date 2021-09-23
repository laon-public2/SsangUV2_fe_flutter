
import 'package:flutter/material.dart' hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'CustomNativeDropDown.dart';

class CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChange;

  CustomDropdown({this.value, this.items, this.onChange});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<DropdownMenuItem<String>> items = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items.clear();

    for (String item in widget.items) {
      items.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        elevation: 2,
        value: widget.value,
        dropdownColor: Colors.white,
        items: items,
        selectedItemBuilder: (BuildContext context) {
          return items.map((e) {
            return Center(child: Text(e.value));
          }).toList();
        },
        onChanged: (value) {
          widget.onChange(value);
          print(value);
        },
      ),
    );
  }
}
