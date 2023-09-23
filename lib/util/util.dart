import 'package:flutter/material.dart';

Widget loadWidgetAsync(Future future, Widget Function(dynamic) widgetGenerator) {
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

Widget _listView(list, Widget Function(Object) tileBuilder,) {
  if (list.isEmpty) {
    return const Center(
      child: Text('Nothing here.'),
    );
  }

  return SizedBox(
            height: 50,
            width: 50,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return tileBuilder(list[index]);
        },
      ),
    ); 
} 

Widget listWithTitleAndButton(final String title, 
                                List<Object> list,
                                Widget Function(dynamic) tileBuilder, 
                                Widget button) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: 
      Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch children horizontally
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                button,
              ],
            ),
          ),
          _listView(list, tileBuilder)
        ],
      ),
    ),
  );
}
