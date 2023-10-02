import 'package:flutter/material.dart';

Widget loadWidgetAsync({required future, 
                        required Widget Function(dynamic) widgetBuilder}) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: $snapshot.error',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 16)),
        );
      } else {
        return widgetBuilder(snapshot.data);
      }
    },
  );
}

bool isValidUrl(String url) {
  return Uri.parse(url).isAbsolute;
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

