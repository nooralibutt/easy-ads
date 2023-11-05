import 'package:flutter/material.dart';

Future showLoaderDialog(BuildContext context, int duration) {
  const alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text("Loading Ad ..."),
      ],
    ),
  );

  Future.delayed(
      Duration(seconds: duration), () => Navigator.of(context).pop());
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => alert,
  );
}
