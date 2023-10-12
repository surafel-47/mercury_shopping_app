// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping_app/_Models/CustomerM.dart';

class Account extends StatelessWidget {
  double scrW = 0;
  double scrH = 0;
  CustomerM customerM;
  Account({required this.customerM});
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "View Profile",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.circle,
                    size: scrH * 0.015,
                  ),
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 34,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [viewProfileTxtBox("First Name", customerM.fname, scrW, scrW * 0.4), viewProfileTxtBox("Last Name", customerM.lname, scrW, scrW * 0.4)],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: viewProfileTxtBox("Email", customerM.email, scrW, scrW * 0.87),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: viewProfileTxtBox("Password", customerM.passWord, scrW, scrW * 0.87),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: viewProfileTxtBox("Phone Number", customerM.phoneNo, scrW, scrW * 0.87),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: SizedBox(
              width: scrW * 0.87,
              height: scrW * 0.25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black // set color
                    ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.keyboard_return), Text("  Return")],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget viewProfileTxtBox(String label, String value, double scrW, double width) {
  TextEditingController txtController = TextEditingController();
  txtController.text = value;
  return SizedBox(
    width: width,
    height: scrW * 0.2,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Material(
        child: SizedBox(
          width: scrW * 0.3,
          child: TextField(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            controller: txtController,
            enabled: false,
            decoration: const InputDecoration(),
          ),
        ),
      ),
    ),
  );
}
