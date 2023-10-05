import 'package:flutter/material.dart';
import 'package:shekel/widgets/delete_confirmation.dart';

bool isValidUrl(String url) {
  return Uri.parse(url).isAbsolute;
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

Future<bool> showDeleteConfirmation(BuildContext context, String text) async {
  return await showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) => DeleteConfirmationWidget(text),
      ) ??
      false;
}
