import 'package:flutter/material.dart';

Future showLoaderDialog(BuildContext context, {int delay = 2}) {
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

  Future.delayed(Duration(seconds: delay), () => Navigator.of(context).pop());
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => alert,
  );
}
