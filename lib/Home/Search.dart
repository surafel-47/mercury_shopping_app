// ignore_for_file: use_key_in_widget_constructors, file_names, must_be_immutable, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:shopping_app/_API/MyDatasRepo.dart';
import 'package:provider/provider.dart';

TextEditingController searchBoxController = TextEditingController();

class Search extends StatelessWidget {
  double scrW = 0;
  double scrH = 0;
  final myFocusNode = FocusNode();

  @override
  void initState() {
    //super.initState();
    myFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);
    scrW = MediaQuery.of(context).size.width;
    scrH = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 17, left: 5),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu, size: scrW * 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: MyBoxShadow,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: scrW * 0.7,
                    height: scrH * 0.07,
                    child: TextField(
                      onSubmitted: (value) {
                        myDatasRepo.getProductList(searchQuery: searchBoxController.text, CatagID: myDatasRepo.selectedCatagID);
                      },
                      controller: searchBoxController,
                      focusNode: myFocusNode,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Search products!',
                        suffixIcon: IconButton(
                          onPressed: () {
                            myDatasRepo.getProductList(searchQuery: searchBoxController.text, CatagID: myDatasRepo.selectedCatagID);
                          },
                          icon: Icon(Icons.search_rounded, size: scrH * 0.05),
                        ),
                      ),
                      style: TextStyle(fontSize: scrH * 0.028),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: scrW * 0.06, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Catagories(
                        catagId: 0,
                        icon: Icons.shop_2_outlined,
                        name: "All",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 1,
                        icon: Icons.shop_2_outlined,
                        name: "Cloths",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 2,
                        icon: Icons.electrical_services_outlined,
                        name: "Electronics",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 3,
                        icon: Icons.masks_outlined,
                        name: "Beauty",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 4,
                        icon: Icons.sports_baseball_outlined,
                        name: "Sports",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 5,
                        icon: Icons.menu_book_sharp,
                        name: "Books",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 6,
                        icon: Icons.laptop,
                        name: "Computers",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 7,
                        icon: Icons.chair_outlined,
                        name: "Furniture",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 8,
                        icon: Icons.create_outlined,
                        name: "Stationery",
                        scrW: scrW,
                      ),
                      Catagories(
                        catagId: 9,
                        icon: Icons.more_horiz_outlined,
                        name: "Others",
                        scrW: scrW,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Catagories extends StatelessWidget {
  int catagId;
  String name;
  IconData icon;
  double scrW;

  Catagories({required this.catagId, required this.name, required this.icon, required this.scrW});

  @override
  Widget build(BuildContext context) {
    final myDatasRepo = Provider.of<MyDatasRepo>(context, listen: true);

    return SizedBox(
      width: scrW * 0.3,
      child: Column(
        children: [
          SizedBox(
            height: scrW * 0.15,
          ),
          InkWell(
            onTap: () {
              myDatasRepo.setSelectedCatagID(catagId);
              myDatasRepo.getProductList(searchQuery: searchBoxController.text, CatagID: catagId);
            },
            child: Container(
              width: scrW * 0.15,
              height: scrW * 0.15,
              decoration: BoxDecoration(
                color: myDatasRepo.selectedCatagID == catagId ? const Color.fromARGB(255, 143, 188, 228) : Colors.white,
                //
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 139, 136, 136),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(icon, size: scrW * 0.08),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(fontSize: scrW * 0.05, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
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
