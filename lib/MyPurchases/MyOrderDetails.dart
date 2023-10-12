// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors,  prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/OrderDetailsM.dart';
import 'package:shopping_app/_Models/OrdersM.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrderDetails extends StatelessWidget {
  OrdersM ordersM;
  double scrW = 0;
  double scrH = 0;
  MyOrderDetails({required this.ordersM});

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
            height: scrH * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Order Details",
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
          SizedBox(
            height: scrH * 0.27,
            width: scrW,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 3),
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
                  padding: const EdgeInsets.only(left: 10, top: 3),
                  child: Row(
                    children: [
                      Text(
                        "Total: ",
                        style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ordersM.total.toStringAsFixed(2),
                        style: TextStyle(fontSize: scrW * 0.05),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 3),
                  child: Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ordersM.orderStatus == 1 ? "Confirmed" : "Pending",
                        style: TextStyle(fontSize: scrW * 0.05, fontWeight: FontWeight.bold, color: ordersM.orderStatus == 1 ? Colors.black : Colors.red),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ordersM.address,
                          style: TextStyle(
                            fontSize: scrW * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: myDatasRepo.getCustomerOrderDetails(custID: myDatasRepo.customerM!.custId, password: myDatasRepo.customerM!.passWord, orderID: ordersM.orderID),
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
                    height: scrH * 0.45,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        OrdersDetailsM ordersDetailsM = OrdersDetailsM();
                        ordersDetailsM.proName = snapshot.data[index]["ProName"] ?? "";
                        ordersDetailsM.proTotal = snapshot.data[index]["ProTotal"] ?? 0;
                        ordersDetailsM.qty = snapshot.data[index]["Qty"] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: scrW,
                            height: scrH * 0.16,
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 239, 232, 232),
                                  boxShadow: MyBoxShadow,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        ordersDetailsM.proName,
                                        style: TextStyle(fontSize: scrH * 0.035, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Qty: ",
                                                style: TextStyle(fontSize: scrH * 0.027, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                ordersDetailsM.qty.toString(),
                                                style: TextStyle(fontSize: scrH * 0.027),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Product Total: ",
                                            style: TextStyle(fontSize: scrH * 0.027, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${ordersDetailsM.proTotal.toStringAsFixed(2)} Birr",
                                            style: TextStyle(fontSize: scrH * 0.027),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          /////////////////////
          SizedBox(height: scrH * 0.02),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: scrW * 0.87,
                height: scrH * 0.1,
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
          SizedBox(height: scrH * 0.02),
        ],
      ),
    );
  }
}

var MyBoxShadow = const [
  BoxShadow(
    color: Colors.grey,
    offset: Offset(4.0, 4.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
  BoxShadow(
    color: Colors.white,
    offset: Offset(-4.0, -4.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  ),
];
