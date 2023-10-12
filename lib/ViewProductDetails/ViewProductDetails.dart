// ignore_for_file:  prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shopping_app/ViewProductDetails/Product.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:shopping_app/_Models/ProductM.dart';
import 'package:shopping_app/_Models/ReviewsM.dart';
import 'package:provider/provider.dart';

double scrW = 0;
double scrH = 0;

class ViewProductDetails extends StatelessWidget {
  ProductM productM;
  ViewProductDetails({required this.productM});
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
            height: scrH * 0.53,
            child: Product(
              productM: productM,
            ),
          ),
          SizedBox(
            height: scrH * 0.43,
            child: FutureBuilder(
              future: myDatasRepo.getReviewsForAProduct(proID: productM.proID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading....");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return const Text("Fetching...");
                } else if (snapshot.data.length == 0) {
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Description(productM: productM),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const Center(
                              child: Text("No Reviews so far"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Description(productM: productM),
                        ]),
                      ),
                      SliverFixedExtentList(
                        itemExtent: scrH * 0.17, // Set the height of each review widget
                        delegate: SliverChildBuilderDelegate(
                          childCount: snapshot.data.length as int, // Number of review widgets
                          (BuildContext context, int index) {
                            ReviewsM reviewsM = ReviewsM();
                            reviewsM.rating = snapshot.data[index]['Rating'] ?? 0;
                            reviewsM.comment = snapshot.data[index]['Comment'] ?? "";
                            reviewsM.reviewerFullName = snapshot.data[index]['ReviewerFullName'] ?? "";

                            return Review(reviewsM: reviewsM); //Review
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class Review extends StatelessWidget {
  ReviewsM reviewsM;
  Review({required this.reviewsM});
  @override
  Widget build(BuildContext context) {
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 25),
      child: Container(
        height: scrH * 0.17,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 234, 234).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Icon(
                      Icons.person,
                      size: scrH * 0.06,
                      color: const Color.fromARGB(255, 15, 11, 93),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 3),
                        child: Text(reviewsM.reviewerFullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          RatingBar(
                            ignoreGestures: true, // Disable the rating bar
                            initialRating: reviewsM.rating.toDouble(),
                            tapOnlyMode: true,
                            itemSize: scrH * 0.036,
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.circle, size: 6),
                          ),
                          Text(reviewsM.rating.toString())
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(reviewsM.comment),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  ProductM productM;
  Description({required this.productM});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.1,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 239, 239),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 174, 171, 171).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            productM.proDesc,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: scrW * 0.045),
          ),
        ),
      ),
    );
  }
}
