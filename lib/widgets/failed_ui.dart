// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class failedUI extends StatelessWidget {
  const failedUI({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey[400]),
        ),
      ),
    );
  }
}
