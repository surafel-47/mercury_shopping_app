// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'package:shopping_app/_Models/ProductM.dart';
import 'package:shopping_app/extra/mySnackBar.dart';

class Product extends StatelessWidget {
  double cardW = 0, cardH = 0;
  ProductM productM;
  Product({required this.productM});

  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);
    final myCart = Provider.of<MyCart>(context, listen: true);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        cardW = constraints.maxWidth;
        cardH = constraints.maxHeight;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: cardH * 0.02),
              child: Container(
                height: cardH * 0.75,
                width: cardH * 0.8,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 190, 183, 183).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: AnotherCarousel(
                    dotBgColor: Colors.transparent,
                    dotSize: 10,
                    dotColor: const Color.fromARGB(255, 151, 151, 145),
                    dotIncreasedColor: Colors.black,
                    autoplayDuration: const Duration(seconds: 4),
                    images: [
                      Image.network(
                        "${myDatasRepo.baseUrl}/${productM.imgUrl1}",
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // This builder function is called when the image fails to load
                          return Image.asset("assets/noProImg.png", fit: BoxFit.cover);
                        },
                      ),
                      Image.network(
                        "${myDatasRepo.baseUrl}/${productM.imgUrl2}",
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // This builder function is called when the image fails to load
                          return Image.asset("assets/noProImg.png", fit: BoxFit.cover);
                        },
                      ),
                      Image.network(
                        "${myDatasRepo.baseUrl}/${productM.imgUrl3}",
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // This builder function is called when the image fails to load
                          return Image.asset("assets/noProImg.png", fit: BoxFit.cover);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(cardH * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          productM.proName,
                          style: TextStyle(fontSize: cardH * 0.06, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "${productM.uPrice.toStringAsFixed(2)}  Birr",
                          style: TextStyle(fontSize: cardH * 0.05, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: cardH * 0.03, right: cardH * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RatingBar(
                        initialRating: productM.avgRating,
                        tapOnlyMode: true,
                        itemSize: cardH * 0.07,
                        minRating: 1,
                        maxRating: 5,
                        ignoreGestures: true, // Disable the rating bar
                        onRatingUpdate: (value) {},
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: Colors.green,
                          ),
                          half: const Icon(
                            Icons.star_half,
                            color: Colors.green,
                          ),
                          empty: const Icon(
                            Icons.star_border_outlined,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: cardW * 0.02),
                        child: Icon(
                          Icons.circle,
                          size: cardW * 0.02,
                        ),
                      ),
                      Text(
                        "(${productM.numOfReviews.toString()})",
                        style: TextStyle(fontSize: cardH * 0.05),
                      ),
                      Icon(
                        Icons.people,
                        size: cardH * 0.055,
                      ),
                    ],
                  ),
                  myCart.isProductInMyCart(productM.proID)
                      ? SizedBox(
                          height: cardH * 0.09,
                          width: cardW * 0.2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              myCart.removeFromCart(productM.proID);
                              mySnackBar(context, "${productM.proName} removed from cart");
                            },
                            child: Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: cardH * 0.09,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: cardH * 0.09,
                          width: cardW * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              myCart.addToCart(productM: productM);
                              mySnackBar(context, "${productM.proName} added to cart");
                            },
                            child: Icon(
                              Icons.add_shopping_cart_sharp,
                              size: cardH * 0.09,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
