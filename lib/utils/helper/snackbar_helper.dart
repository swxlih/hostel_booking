import 'package:flutter/material.dart';
enum SnackbarStatus {
  success,
  error,
  warning,
  info,
}



void showStatusSnackBar(
  BuildContext context,
  String message,
  SnackbarStatus status,
) {
  Color bgColor;
  IconData icon;

  switch (status) {
    case SnackbarStatus.success:
      bgColor = Colors.green;
      icon = Icons.check_circle;
      break;

    case SnackbarStatus.error:
      bgColor = Colors.red;
      icon = Icons.error;
      break;

    case SnackbarStatus.warning:
      bgColor = Colors.orange;
      icon = Icons.warning;
      break;

    case SnackbarStatus.info:
      bgColor = Colors.blue;
      icon = Icons.info;
      break;
  }

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
