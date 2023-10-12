// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class MsgShower extends StatelessWidget {
  double scrH = 0, scrW = 0;
  String title, Msg;
  bool IsgoodNews;
  MsgShower({required this.title, required this.Msg, required this.IsgoodNews});

  @override
  Widget build(BuildContext context) {
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: scrW * 0.9,
        height: scrH * 0.6,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.0), Colors.blue.withOpacity(0.1)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              width: scrW * 0.85,
              height: scrW * 0.85,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                  title,
                  style: TextStyle(fontSize: scrW * 0.1, fontWeight: FontWeight.bold),
                ),
                IsgoodNews
                    ? Icon(
                        Icons.check_circle,
                        size: scrH * 0.13,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.error,
                        size: scrH * 0.13,
                        color: Colors.red,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    Msg,
                    style: TextStyle(fontSize: scrW * 0.05, color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay", style: TextStyle(fontSize: scrW * 0.07)),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
