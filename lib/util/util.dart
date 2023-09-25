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

Widget _listView(list, Widget Function(Object) tileBuilder,) {
  if (list.isEmpty) {
    return const Center(
      child: Text('Nothing here.'),
    );
  }

  return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return tileBuilder(list[index]);
        },
    ); 
} 

Widget listWithTitleAndButtons({required final String title, 
                              required List<Object> list,
                              required Widget Function(dynamic) tileBuilder, 
                              List<Widget> buttons = const []}) {
  return Scaffold(
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
                buttons.isNotEmpty ? Row(
                  children: buttons,
                ) : Container()
              ],
            ),
          ),
          _listView(list, tileBuilder)
        ],
      ),
  );
}
