import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { USER, NGO }

class UserModel {
  String? id;
  String? userType;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? address;
  String? date;
  NGOData? nGOData;

  UserModel(
      {this.id,
      this.userType,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.address,
      this.date,
      this.nGOData});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['userType'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    address = json['address'];
    date = json['date'];
    nGOData =
        json['NGO Data'] != null ? NGOData.fromJson(json['NGO Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userType'] = userType;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['address'] = address;
    data['date'] = date;
    if (nGOData != null) {
      data['NGO Data'] = nGOData!.toJson();
    }
    return data;
  }
}

class NGOData {
  String? name;
  String? desc;
  String? pic;
  String? addressProof;
  GeoPoint? location;

  NGOData({this.name, this.desc, this.pic, this.addressProof, this.location});

  NGOData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
    pic = json['pic'];
    addressProof = json['addressProof'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['desc'] = desc;
    data['pic'] = pic;
    data['addressProof'] = addressProof;
    data['location'] = location;
    return data;
  }
}
