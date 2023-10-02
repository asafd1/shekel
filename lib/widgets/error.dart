import 'package:flutter/material.dart';

class ErrorWidgetWithText extends StatelessWidget {
  final String errorMessage;

  const ErrorWidgetWithText({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.red, // Customize the text color
        ),
      ),
    );
  }
}
