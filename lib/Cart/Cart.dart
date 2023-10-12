// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/MsgShower/MsgShower.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:shopping_app/SignIn/SignIn.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/_Models/ProductM.dart';

class Cart extends StatelessWidget {
  double scrH = 0, scrW = 0;
  @override
  Widget build(BuildContext context) {
    final myCart = Provider.of<MyCart>(context, listen: true);
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);
    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My Cart",
                style: TextStyle(fontSize: scrH * 0.04, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.circle,
                  size: scrH * 0.015,
                ),
              ),
              Icon(
                Icons.shopping_cart_checkout,
                size: scrH * 0.04,
              ),
              Text(
                "(${myCart.myCartProductList.length})",
                style: TextStyle(fontSize: scrH * 0.025),
              ),
            ],
          ),
        ),
        myCart.isMyCartEmpty()
            ? Expanded(
                flex: 7,
                child: Container(
                  child: Lottie.asset('assets/emptyCart.json'),
                ),
              )
            : Expanded(
                flex: 7,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: myCart.myCartProductList.length,
                  itemBuilder: (context, index) {
                    return CartItem(productM: myCart.myCartProductList[index]);
                  },
                ),
              ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Order Summary!",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: scrH * 0.032),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Sub Total", style: TextStyle(fontSize: scrH * 0.022)),
                  Text("${(myCart.total * 0.85).toStringAsFixed(2)} Birr", style: TextStyle(fontSize: scrH * 0.022))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Vat(15%)", style: TextStyle(fontSize: scrH * 0.022)),
                  Text("${(myCart.total * 0.15).toStringAsFixed(2)} Birr", style: TextStyle(fontSize: scrH * 0.022))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Total", style: TextStyle(fontSize: scrH * 0.022, fontWeight: FontWeight.bold)),
                  Text("${myCart.total.toStringAsFixed(2)} Birr", style: TextStyle(fontSize: scrH * 0.022, fontWeight: FontWeight.bold))
                ],
              ),
              myDatasRepo.custLoggedIn
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Material(
                                  child: OpenStreetMapSearchAndPick(
                                    center: LatLong(9.02497, 38.74689), //Addis Abeba
                                    buttonColor: Colors.blue,
                                    buttonText: 'Pick Delivery Location',
                                    onPicked: (pickedData) {
                                      String pickedAddress = pickedData.address;
                                      if (pickedAddress.length > 250) {
                                        pickedAddress = pickedAddress.substring(0, 250);
                                      }
                                      myDatasRepo.setOrderAddress(pickedAddress);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.location_on_outlined),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            //Make Purhase here SUiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                            if (myDatasRepo.orderDeliveryAddress == "") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MsgShower(
                                    IsgoodNews: false,
                                    Msg: "No Deilvery Address Given",
                                    title: "",
                                  );
                                },
                              );
                            } else if (myCart.isMyCartEmpty()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MsgShower(
                                    IsgoodNews: false,
                                    Msg: "Nothing is free to Buy!",
                                    title: "Cart's Empty",
                                  );
                                },
                              );
                            } else {
                              List<Map<String, dynamic>> productListInMap = myCart.myCartProductList.map((product) => product.toJson()).toList();
                              String productListJson = jsonEncode(productListInMap);
                              bool isOrderSuccessfull = await myDatasRepo.makeAnOrder(
                                  custID: myDatasRepo.customerM!.custId,
                                  password: myDatasRepo.customerM!.passWord,
                                  address: myDatasRepo.orderDeliveryAddress,
                                  productListJson: productListJson);
                              if (!isOrderSuccessfull) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MsgShower(
                                      IsgoodNews: false,
                                      Msg: "Sorry Your Order has failed :(",
                                      title: "Order Failed",
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MsgShower(
                                      IsgoodNews: true,
                                      Msg: "Your order has been successfully submitted.",
                                      title: "Order Accepted!",
                                    );
                                  },
                                );
                                myDatasRepo.clearOrderAddress();
                                myCart.emptyCart();
                                //paymnetttttttttttttttttttttttt
                              }
                            }
                          },
                          child: Text(
                            "Checkout!",
                            style: TextStyle(fontSize: scrH * 0.03),
                          ),
                        ),
                        SizedBox(width: scrW * 0.15),
                      ],
                    )
                  : SizedBox(
                      width: scrW * 0.5,
                      height: scrH * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // set color
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
                          children: const [Icon(Icons.keyboard_return), Text("Log In!")],
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}

//---------------------------------------------

class CartItem extends StatelessWidget {
  double scrH = 0, scrW = 0;
  ProductM productM;
  CartItem({required this.productM});

  TextEditingController qtyController = TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    final myCart = Provider.of<MyCart>(context, listen: true);

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: MyBoxShadow,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productM.proName,
                        style: TextStyle(fontSize: scrW * 0.05, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 96, 44, 27)),
                      ),
                      Text(
                        "${productM.uPrice.toStringAsFixed(2)} Birr",
                        style: TextStyle(fontSize: scrW * 0.04, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            myCart.subQtyByOne(productM.proID);
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: const [BoxShadow(color: Color.fromARGB(255, 173, 153, 153), blurRadius: 5, spreadRadius: 1)],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                              child: Text(
                            myCart.getQty(productM.proID).toString(),
                            style: TextStyle(fontSize: scrW * 0.05, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            myCart.addQtyByOne(productM.proID);
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  myCart.removeFromCart(productM.proID);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.red,
                ),
                child: const Icon(Icons.remove_shopping_cart_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<BoxShadow> MyBoxShadow = [
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
