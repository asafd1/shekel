import 'package:flutter/material.dart';

Widget loadWidgetAsync(Future future, Function widgetGenerator) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return widgetGenerator(snapshot.data);
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: $snapshot.error',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 16)),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
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
