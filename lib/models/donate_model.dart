import 'package:cloud_firestore/cloud_firestore.dart';

enum DonationStatus { Pending, Accepted }

enum DonationType { Clothes, Food, Books, Others }

enum DonationDeliveryType { PickUp, DropOff }

class DonationModel {
  String? donationId;
  String? userId;
  String? userName;
  String? ngoId;
  String? ngoName;
  String? status;
  String? donationType;
  int? numberOfItems;
  String? mode;
  String? img;
  String? address;
  Timestamp? addedOn;
  ClothesModel? clothes;
  FoodsModel? food;
  BooksModel? books;

  DonationModel(
      {this.donationId,
      this.userId,
      this.userName,
      this.ngoId,
      this.ngoName,
      this.status,
      this.donationType,
      this.numberOfItems,
      this.mode,
      this.img,
      this.address,
      this.addedOn,
      this.clothes,
      this.food,
      this.books});

  DonationModel.fromJson(Map<String, dynamic> json) {
    donationId = json['donationId'];
    userId = json['userId'];
    userName = json['userName'];
    ngoId = json['ngoId'];
    ngoName = json['ngoName'];
    status = json['status'];
    donationType = json['donationType'];
    numberOfItems = json['numberOfItems'];
    mode = json['mode'];
    img = json['img'];
    addedOn = json['addedOn'];
    address = json['address']; //!= null ? new json['address'];
    clothes =
        json['clothes'] != null ? ClothesModel.fromJson(json['clothes']) : null;
    food = json['food'] != null ? FoodsModel.fromJson(json['food']) : null;
    books = json['books'] != null ? BooksModel.fromJson(json['books']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donationId'] = donationId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['ngoId'] = ngoId;
    data['ngoName'] = ngoName;
    data['status'] = status;
    data['donationType'] = donationType;
    data['numberOfItems'] = numberOfItems;
    data['mode'] = mode;
    data['img'] = img;
    data['addedOn'] = addedOn;
    // if (address != null) {
    data['address'] = address; //!.toJson();
    // }
    if (clothes != null) {
      data['clothes'] = clothes!.toJson();
    }
    if (food != null) {
      data['food'] = food!.toJson();
    }
    if (books != null) {
      data['books'] = books!.toJson();
    }
    return data;
  }
}

// class Address {
//   GeoPoint? location;
//   String? text;

//   Address({this.location, this.text});

//   Address.fromJson(Map<String, dynamic> json) {
//     location = json['location'].cast();
//     text = json['text'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['location'] = location;
//     data['text'] = text;
//     return data;
//   }
// }

class ClothesModel {
  List<String>? clothesFor;
  List<String>? clothesType;

  ClothesModel({this.clothesFor, this.clothesType});

  ClothesModel.fromJson(Map<String, dynamic> json) {
    clothesFor = json['clothesFor'].cast<String>();
    clothesType = json['clothesType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clothesFor'] = clothesFor;
    data['clothesType'] = clothesType;
    return data;
  }
}

class FoodsModel {
  List<String>? foodType;

  FoodsModel({this.foodType});

  FoodsModel.fromJson(Map<String, dynamic> json) {
    foodType = json['foodType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodType'] = foodType;
    return data;
  }
}

class BooksModel {
  List<String>? bookType;

  BooksModel({this.bookType});

  BooksModel.fromJson(Map<String, dynamic> json) {
    bookType = json['bookType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookType'] = bookType;
    return data;
  }
}

class OthersModel {}
