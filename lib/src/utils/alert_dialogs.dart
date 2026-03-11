import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final String description;
  final VoidCallback? onOkay;

  const MyAlertDialog(
    this.title,
    this.description,
    this.buttonTitle, {
    super.key,
    this.onOkay,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text(buttonTitle),
          onPressed: () {
            Navigator.pop(context);
            onOkay?.call();
          },
        ),
      ],
    );
  }
}

Future<void> showSingleButton(
  BuildContext context, {
  VoidCallback? onOkay,
  String title = 'Alert',
  required String description,
  String buttonTitle = 'Okay',
  bool barrierDismissible = true,
}) {
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) =>
        MyAlertDialog(title, description, buttonTitle, onOkay: onOkay),
  );
}
