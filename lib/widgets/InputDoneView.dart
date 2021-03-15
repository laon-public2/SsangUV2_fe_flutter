import 'package:flutter/material.dart';

class InputDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,2),
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  blurRadius: 8.0,
                ),
              ]
          ),
        child: Center(
          child: Icon(Icons.check, size: 30, color: Theme.of(context).primaryColor,),
        ),
        ),
    );
  }
}
// Focus.of(context).requestFocus(new FocusNode());
