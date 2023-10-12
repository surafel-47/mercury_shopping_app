// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shopping_app/SignIn/SignIn.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/_Models/MyCart.dart';

class SideDrawerNotLoggedIN extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);
    final myCart = Provider.of<MyCart>(context, listen: true);
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: SizedBox(
              width: 130,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black // set color
                    ),
                onPressed: () {
                  myDatasRepo.loggOutCustomer();
                  myCart.emptyCart();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SignIn();
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.login_rounded), Text("Log In!")],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
