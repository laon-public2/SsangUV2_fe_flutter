import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onClick;
  CustomButton({this.title = "", this.enable = true, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: enable ? () {
        this.onClick();
      }: null,
      color: Theme.of(context).primaryColor,
      elevation: 0.0,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title),
    );
  }
}
