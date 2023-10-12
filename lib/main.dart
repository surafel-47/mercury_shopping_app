// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app/MainBoard.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'dart:io';

void main(List<String> args) {
  // Disable SSL certificate verification for Image.network()
  HttpOverrides.global = CustomHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyCart>(create: (_) => MyCart()),
        ChangeNotifierProvider<MyDatasRepo>(create: (_) => MyDatasRepo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: GetBaseUrl()),
      ),
    ),
  );
}

class GetBaseUrl extends StatelessWidget {
  TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset("assets/logo.png"),
              ),
              Text(
                'Enter IP and Port',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: txtController,
                decoration: InputDecoration(
                  hintText: 'Ex <https://192.168.0.21:9000>',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  myDatasRepo.baseUrl = txtController.text;
                  myDatasRepo.getProductList();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainBoard()),
                  );
                },
                child: Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  }
}
