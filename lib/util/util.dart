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
              style: const TextStyle(fontSize:16)),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}
