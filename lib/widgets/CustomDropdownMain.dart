import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CustomDropdownMain extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChange;

  CustomDropdownMain({this.value, this.items, this.onChange});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdownMain> {
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
        elevation: 1,
        value: widget.value,
        dropdownColor: Colors.white,
        icon: Container(
          padding: const EdgeInsets.only(left: 10),
          child: ImageIcon(AssetImage('assets/icon/dropdown.png')),
        ),
        items: items,
        selectedItemBuilder: (BuildContext context) {
          return items.map((e) {
            return Center(
                child: Text(
              e.value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ));
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
