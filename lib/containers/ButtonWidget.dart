import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String title;
  final Color bodyColor;
  final Color textColor;
  final Function onPressed;

  ButtonWidget({
    required Key key,
    required this.title,
    this.bodyColor = Colors.blue,
    this.textColor = Colors.black,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        "${widget.title}",
        style: TextStyle(
          color: widget.textColor,
        ),
      ),
      color: widget.bodyColor,
      onPressed: () {
        widget.onPressed();
      },
    );
  }
}
