// ignore_for_file: file_names

class ProductM {
  int proID = 0;
  int catagID = 0;
  String proName = "";
  double uPrice = 0;
  int qty = 1;
  String proDesc = "";
  double avgRating = 0;
  int numOfReviews = 0;
  String imgUrl1 = "";
  String imgUrl2 = "";
  String imgUrl3 = "";

  Map<String, dynamic> toJson() {
    return {
      'proID': proID,
      'catagID': catagID,
      'proName': proName,
      'uPrice': uPrice,
      'qty': qty,
      'proDesc': proDesc,
      'avgRating': avgRating,
      'numOfReviews': numOfReviews,
      'imgUrl1': imgUrl1,
      'imgUrl2': imgUrl2,
      'imgUrl3': imgUrl3,
    };
  }
}
