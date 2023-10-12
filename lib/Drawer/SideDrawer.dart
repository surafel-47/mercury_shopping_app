// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Account/Account.dart';
import 'package:shopping_app/MainBoard.dart';
import 'package:shopping_app/MyPurchases/MyOrders.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'package:shopping_app/extra/mySnackBar.dart';

class SideDrawer extends StatelessWidget {
  double scrW = 0;
  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: false);
    final myCart = Provider.of<MyCart>(context, listen: false);

    scrW = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 221, 218, 218),
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Image.network(
                        "${myDatasRepo.baseUrl}/${myDatasRepo.customerM?.imgUrl}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/noProfile.png", // Fallback image asset
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: scrW * 0.06),
                      child: Text(
                        "${myDatasRepo.customerM!.fname} ${myDatasRepo.customerM!.lname}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Account(customerM: myDatasRepo.customerM!);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            myDatasRepo.customerM!.email,
                            style: const TextStyle(color: Color.fromARGB(255, 166, 170, 252)),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.mark_email_read_outlined,
                            color: Color.fromARGB(255, 170, 167, 241),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Account(customerM: myDatasRepo.customerM!);
                  },
                );
              },
              child: ListTile(
                leading: Icon(Icons.settings, size: scrW * 0.08, color: Colors.black),
                title: Text("Account View", style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MyOrders();
                  },
                );
              },
              child: ListTile(
                leading: Icon(Icons.history_rounded, size: scrW * 0.08, color: Colors.black),
                title: Text("My Purchases", style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const Expanded(flex: 3, child: SizedBox()),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                mySnackBar(context, "Logged Out!🗿");

                myDatasRepo.loggOutCustomer();
                myCart.emptyCart();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainBoard()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.logout, size: scrW * 0.08, color: Colors.black),
                title: Text("Log Out", style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
