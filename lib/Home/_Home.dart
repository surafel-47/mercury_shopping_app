// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:shopping_app/Home/Search.dart';

import 'ViewProducts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Search(),
        ),
        Expanded(
          flex: 11,
          child: ViewProducts(),
        )
      ],
    );
  }
}
