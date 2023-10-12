// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/MainBoard.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/extra/mySnackBar.dart';

class SignIn extends StatelessWidget {
  double scrW = 0;
  double scrH = 0;
  TextEditingController emailPhoneNoTxtController = TextEditingController();
  TextEditingController passWordTxtContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 236, 237, 242),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: scrH * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(70),
                  child: Image.asset(
                    "assets/logo.png",
                    height: scrH * 0.2,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: MyBoxShadow,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: scrW * 0.8,
                    height: scrW * 0.15,
                    child: TextField(
                      controller: emailPhoneNoTxtController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Email/Phone-Number',
                        prefixIcon: Icon(Icons.person_3_outlined, size: scrH * 0.05),
                      ),
                      style: TextStyle(fontSize: scrH * 0.028),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: MyBoxShadow,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: scrW * 0.8,
                    height: scrW * 0.15,
                    child: TextField(
                      controller: passWordTxtContoller,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.key, size: scrH * 0.05),
                      ),
                      style: TextStyle(fontSize: scrH * 0.028),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: scrW * 0.8,
                height: scrW * 0.2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black // set color
                      ),
                  onPressed: () async {
                    Future<bool> custLoggedIn = myDatasRepo.loginCustomerAndGetCustomerDetails(
                      emailOrPhoneNumber: emailPhoneNoTxtController.text,
                      passWord: passWordTxtContoller.text,
                    );

                    bool loggedIn = await custLoggedIn;

                    // ignore: use_build_context_synchronously
                    if (loggedIn) {
                      mySnackBar(context, "Log In Successfull!");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainBoard()),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      mySnackBar(context, "Log In Failed, Please Try Again 🗿!");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login),
                      Text(
                        "  Log In",
                        style: TextStyle(fontSize: scrH * 0.02),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign in and let's get Started!!",
                      style: TextStyle(color: Color.fromARGB(255, 64, 67, 125), fontSize: 15),
                    ),
                    const Icon(Icons.local_grocery_store_outlined, color: Color.fromARGB(255, 33, 31, 77))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var MyBoxShadow = [
  const BoxShadow(
    color: Colors.grey,
    offset: Offset(4.0, 4.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
  const BoxShadow(
    color: Colors.white,
    offset: Offset(-4.0, -4.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
];
