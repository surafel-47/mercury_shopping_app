// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:shopping_app/Cart/Cart.dart';
import 'package:shopping_app/Drawer/SideDrawer.dart';
import 'package:shopping_app/Drawer/SideDrawerNotLoggedIn.dart';
import 'package:shopping_app/Home/_Home.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'package:provider/provider.dart';

class MainBoard extends StatefulWidget {
  const MainBoard({super.key});

  @override
  State<MainBoard> createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard> {
  int selIndex = 0;

  @override
  Widget build(BuildContext context) {
    final myCart = Provider.of<MyCart>(context, listen: true);
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);

    List<Widget> items = [Home(), Cart()];
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: myDatasRepo.custLoggedIn ? SideDrawer() : SideDrawerNotLoggedIN(),
        body: IndexedStack(
          index: selIndex,
          children: items,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            selIndex = value;
            setState(() {});
          },
          currentIndex: selIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: myCart.isMyCartEmpty() ? Icon(Icons.shopping_cart_outlined) : Icon(Icons.add_shopping_cart),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
