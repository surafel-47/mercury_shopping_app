// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shopping_app/_Models/ProductM.dart';

class MyCart extends ChangeNotifier {
  List<ProductM> myCartProductList = [];

  bool isMyCartEmpty() {
    return myCartProductList.isEmpty;
  }

  int getQty(int proID) {
    for (var myCartProduct in myCartProductList) {
      if (myCartProduct.proID == proID) return myCartProduct.qty;
    }
    return -1;
  }

  bool isProductInMyCart(int proId) {
    for (var myCartProduct in myCartProductList) {
      if (myCartProduct.proID == proId) return true;
    }
    return false;
  }

  double total = 0;
  void updateTotalValue() {
    double finalValue = 0;
    for (var myCartProduct in myCartProductList) {
      finalValue = finalValue + (myCartProduct.qty * myCartProduct.uPrice);
    }
    total = finalValue;
  }

  void addToCart({required productM}) {
    myCartProductList.add(productM);
    updateTotalValue();
    notifyListeners();
  }

  void addQtyByOne(int proID) {
    for (var myCartProduct in myCartProductList) {
      if (myCartProduct.proID == proID) {
        myCartProduct.qty += 1;
      }
    }
    updateTotalValue();
    notifyListeners();
  }

  void subQtyByOne(int proID) {
    for (var myCartProduct in myCartProductList) {
      if (myCartProduct.proID == proID && myCartProduct.qty > 1) {
        myCartProduct.qty -= 1;
      }
    }

    updateTotalValue();
    notifyListeners();
  }

  void emptyCart() {
    myCartProductList.clear();
    updateTotalValue();
    notifyListeners();
  }

  void removeFromCart(int proID) {
    myCartProductList.removeWhere(
      (myCartProduct) => myCartProduct.proID == proID,
    );
    updateTotalValue();
    notifyListeners();
  }
}
