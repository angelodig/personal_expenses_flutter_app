import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  const AdaptiveFlatButton(
      {super.key, required this.text, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ))
        : ElevatedButton(
            onPressed: handler,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
  }
}
