import 'package:flutter/material.dart';

class ResuseTextWidget extends StatelessWidget {
  final String title;

  const ResuseTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
