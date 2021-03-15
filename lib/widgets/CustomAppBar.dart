import 'package:flutter/material.dart';

AppBar defaultAppBar(BuildContext context, String title) {
  return AppBar(
    leading: Column(children: [
      Text('test'),
      Text('test'),
      Text('test'),
    ]),
    actions: [
      InkWell(
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    ],
  );
}
