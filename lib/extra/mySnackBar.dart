// ignore_for_file: file_names

import 'package:flutter/material.dart';

void mySnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 700),
      content: Text(msg),
    ),
  );
}
