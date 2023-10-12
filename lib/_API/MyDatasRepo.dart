// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:convert';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shopping_app/_Models/CustomerM.dart';

class MyDatasRepo extends ChangeNotifier {
  late final Dio myDioHttp;
  int selectedCatagID = 0;
  Future<dynamic>? productListJson;
  Future<dynamic>? ordersListJson;
  CustomerM? customerM = CustomerM();
  String baseUrl = "https://192.168.0.21:9000";
  bool custLoggedIn = false;
  String orderDeliveryAddress = "";

  void setOrderAddress(String address) {
    orderDeliveryAddress = address;
    notifyListeners();
  }

  void clearOrderAddress() {
    orderDeliveryAddress = "";
    notifyListeners();
  }

  void setSelectedCatagID(int id) {
    selectedCatagID = id;
    notifyListeners();
  }

  MyDatasRepo() {
    myDioHttp = Dio();
    // Disable SSL certificate verification
    (myDioHttp.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    getProductList(searchQuery: "", CatagID: 0);
  }

  Future<void> getProductList({String searchQuery = "", int CatagID = 0}) async {
    var response = await myDioHttp.get(
      "$baseUrl/Api/getProductList",
      queryParameters: searchQuery.isEmpty
          ? {'CatagoryID': CatagID}
          : {
              'searchQuery': searchQuery,
              'CatagoryID': CatagID,
            },
    );
    if (response.statusCode == 200) {
      productListJson = Future<dynamic>.value(jsonDecode(response.data.toString()));
      notifyListeners();
    } else {
      notifyListeners();
      throw Exception("Server isn't in the mood");
    }
  }

  Future<bool> loginCustomerAndGetCustomerDetails({String emailOrPhoneNumber = "", String passWord = ""}) async {
    try {
      var response = await myDioHttp.get(
        "$baseUrl/Api/loginCustomer",
        queryParameters: {
          'EmailOrPhoneNumber': emailOrPhoneNumber,
          'PassWord': passWord,
        },
      );

      if (response.statusCode == 200) {
        if (response.data.toString() != "Login Failed") {
          var customerJson = await Future<dynamic>.value(jsonDecode(response.data.toString()));

          customerM!.custId = customerJson['CustID'] ?? customerM!.custId;
          customerM!.fname = customerJson['Fname'] ?? customerM!.fname;
          customerM!.lname = customerJson['Lname'] ?? customerM!.lname;
          customerM!.passWord = customerJson['PassWord'] ?? customerM!.passWord;
          customerM!.email = customerJson['Email'] ?? customerM!.email;
          customerM!.phoneNo = customerJson['PhoneNumber'] ?? customerM!.phoneNo;
          customerM!.imgUrl = customerJson['CustImg'] ?? customerM!.imgUrl;
          custLoggedIn = true;
          notifyListeners();
          return true;
        }
      }
      custLoggedIn = false;
      return false;
    } catch (Exepction) {
      return false;
    }
  }

  Future<dynamic> getCustomerOrders({required int custID, required String password}) async {
    var response = await myDioHttp.get(
      "$baseUrl/Api/getCustomerOrdersHistory",
      queryParameters: {
        'CustID': custID,
        'PassWord': password,
      },
    );
    if (response.statusCode == 200) {
      return ordersListJson = Future<dynamic>.value(jsonDecode(response.data.toString()));
    } else {
      throw Exception("Server isn't in the mood");
    }
  }

  Future<dynamic> getCustomerOrderDetails({required int custID, required String password, required int orderID}) async {
    var response = await myDioHttp.get(
      "$baseUrl/Api/getCustomerOrdersDetails",
      queryParameters: {'CustID': custID, 'PassWord': password, 'OrderID': orderID},
    );
    if (response.statusCode == 200) {
      return ordersListJson = Future<dynamic>.value(jsonDecode(response.data.toString()));
    } else {
      throw Exception("Server isn't in the mood");
    }
  }

  Future<dynamic> getReviewsForAProduct({int proID = 0}) async {
    var response = await myDioHttp.get(
      "$baseUrl/Api/getReviewsForAProduct",
      queryParameters: {'proID': proID},
    );
    if (response.statusCode == 200) {
      return Future<dynamic>.value(jsonDecode(response.data.toString()));
    } else {
      throw Exception("Server isn't in the mood");
    }
  }

  Future<bool> makeAnOrder({required int custID, required String password, required String address, required String productListJson}) async {
    var response = await myDioHttp.get(
      "$baseUrl/Api/CheckOutAPI",
      queryParameters: {'custID': custID, 'password': password, 'address': address, 'productListJson': productListJson},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void loggOutCustomer() {
    custLoggedIn = false;
    customerM!.custId = 0;
    customerM!.imgUrl = "";
    customerM!.fname = "";
    customerM!.email = "";
    customerM!.passWord = "";
    customerM!.phoneNo = "";
    customerM!.lname = "";
  }
}
