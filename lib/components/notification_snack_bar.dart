import 'package:flutter/material.dart' show Colors, SnackBar, Text;

SnackBar notificationSnackBar(String message) {
  return SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(message),
    showCloseIcon: true,
    closeIconColor: Colors.red,
  );
}
