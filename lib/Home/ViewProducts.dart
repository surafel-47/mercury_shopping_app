// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shopping_app/ViewProductDetails/ViewProductDetails.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/MyCart.dart';
import 'package:shopping_app/_Models/ProductM.dart';
import 'package:shopping_app/extra/mySnackBar.dart';

class ViewProducts extends StatelessWidget {
  const ViewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);

    return FutureBuilder(
      future: myDatasRepo.productListJson,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null) {
          return Text("Loading...");
        } else if (snapshot.data.length == 0) {
          return Text("No Results");
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.54, crossAxisCount: 2, mainAxisSpacing: 10),
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ProductM productM = ProductM();
              productM.proID = snapshot.data[index]["ProID"] ?? productM.proID;
              productM.proName = snapshot.data[index]["ProName"] ?? productM.proName;
              productM.uPrice = snapshot.data[index]["UPrice"] ?? productM.qty;
              productM.proDesc = snapshot.data[index]["ProDesc"] ?? productM.qty;
              productM.catagID = snapshot.data[index]["CatagID"] ?? productM.catagID;
              productM.avgRating = snapshot.data[index]["AvgRating"] ?? productM.avgRating;
              productM.numOfReviews = snapshot.data[index]["NumOfReviews"] ?? productM.numOfReviews;
              productM.imgUrl1 = snapshot.data[index]["Img1"] ?? "";
              productM.imgUrl2 = snapshot.data[index]["Img2"] ?? "";
              productM.imgUrl3 = snapshot.data[index]["Img3"] ?? "";
              return ProductCard(
                productM: productM,
              );
            },
          );
        }
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard({required this.productM});

  double cardW = 0;
  double cardH = 0;
  ProductM productM;
  @override
  Widget build(BuildContext context) {
    final myCart = Provider.of<MyCart>(context, listen: true);
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          cardW = constraints.maxWidth;
          cardH = constraints.maxHeight;
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 228, 222, 222).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ViewProductDetails(productM: productM);
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: cardH * 0.75,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: cardH * 0.75,
                            child: Image.network(
                              "${myDatasRepo.baseUrl}/${productM.imgUrl1}",
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                // This builder function is called when the image fails to load
                                return Image.asset("assets/noProImg.png", fit: BoxFit.cover);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                              height: cardH * 0.16,
                              width: cardW,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6, top: 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    productM.proName,
                                    style: TextStyle(fontSize: cardH * 0.053, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: cardH * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        RatingBar(
                          initialRating: productM.avgRating,
                          tapOnlyMode: true,
                          itemSize: cardH * 0.059,
                          minRating: 1,
                          maxRating: 5,
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
                          padding: EdgeInsets.symmetric(horizontal: cardW * 0.03),
                          child: Icon(
                            Icons.circle,
                            size: cardW * 0.03,
                          ),
                        ),
                        Text(
                          "(${productM.numOfReviews})",
                          style: TextStyle(fontSize: cardH * 0.044),
                        ),
                        Icon(
                          Icons.people,
                          size: cardH * 0.05,
                        ),
                      ],
                    ),
                    Row(
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
                                "${productM.uPrice.toStringAsFixed(2)} Birr",
                                style: TextStyle(fontSize: cardH * 0.05, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: myCart.isProductInMyCart(productM.proID)
                                ? SizedBox(
                                    height: cardH * 0.1,
                                    width: cardW * 0.4,
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
                                    height: cardH * 0.1,
                                    width: cardW * 0.4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        MyDatasRepo m = MyDatasRepo();
                                        m.getProductList(searchQuery: "1", CatagID: 1);
                                        myCart.addToCart(productM: productM);
                                        mySnackBar(context, "${productM.proName} added to cart");
                                      },
                                      child: Icon(
                                        Icons.add_shopping_cart_sharp,
                                        size: cardH * 0.09,
                                      ),
                                    ),
                                  )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
