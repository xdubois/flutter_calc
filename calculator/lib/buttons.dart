import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final color;
  final textColor;
  final String text;
  final buttonTapped;

  MyButton(
      {this.text,
      this.color,
      this.textColor = Colors.black,
      this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        buttonTapped();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: this.color,
          child: Center(
              child: Text(this.text,
                  style: TextStyle(
                      color: this.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
