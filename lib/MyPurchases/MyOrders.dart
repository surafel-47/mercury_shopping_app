// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, file_names, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shopping_app/MyPurchases/MyOrderDetails.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/_Models/OrdersM.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatelessWidget {
  double scrW = 0;
  double scrH = 0;

  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: false);

    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: scrH * 0.13,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "My Purchases",
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
                  Icons.shopping_bag_outlined,
                  size: 34,
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: myDatasRepo.getCustomerOrders(custID: myDatasRepo.customerM!.custId, password: myDatasRepo.customerM!.passWord),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return const Text("Loading...");
              } else if (snapshot.data.length == 0) {
                return const Text("No Orders Yet");
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: scrH * 0.6,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        OrdersM ordersM = OrdersM();
                        ordersM.orderID = snapshot.data[index]["OrderID"] ?? 0;
                        ordersM.custID = snapshot.data[index]["CustID"] ?? 0;
                        ordersM.total = snapshot.data[index]["Total"] ?? 0;
                        ordersM.address = snapshot.data[index]["Address"] ?? "";
                        ordersM.orderStatus = snapshot.data[index]["OrderStatus"] ?? 0;
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Orders(
                            ordersM: ordersM,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: scrH * 0.05),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: scrW * 0.87,
                height: scrH * 0.12,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black // set color
                      ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Icon(Icons.keyboard_return), const Text("  Return")],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: scrH * 0.05),
        ],
      ),
    );
  }
}

class Orders extends StatelessWidget {
  double scrW = 0;
  double scrH = 0;
  OrdersM ordersM;
  Orders({required this.ordersM});

  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyOrderDetails(
              ordersM: ordersM,
            );
          },
        );
      },
      child: Container(
        height: scrH * 0.3,
        decoration: BoxDecoration(
          color: ordersM.orderStatus == 1 ? const Color.fromARGB(255, 233, 173, 173) : const Color.fromARGB(255, 219, 111, 111),
          boxShadow: MyBoxShadow,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Date: ",
                          style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(ordersM.date),
                          style: TextStyle(fontSize: scrW * 0.05),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${ordersM.total.toStringAsFixed(2)} Birr",
                          style: TextStyle(fontSize: scrW * 0.06),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Text(
                            "Status: ",
                            style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ordersM.orderStatus == 1 ? "Confirmed" : "Pending",
                            style: TextStyle(fontSize: scrW * 0.06),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
