import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? ngoID;
  String? image;
  String? caption;
  Timestamp? startDate;
  Timestamp? endDate;
  Timestamp? addedOn;

  PostModel(
      {this.ngoID,
      this.image,
      this.caption,
      this.startDate,
      this.endDate,
      this.addedOn});

  PostModel.fromJson(Map<String, dynamic> json) {
    ngoID = json['ngoID'];
    image = json['image'];
    caption = json['caption'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    addedOn = json['addedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ngoID'] = ngoID;
    data['image'] = image;
    data['caption'] = caption;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['addedOn'] = addedOn;
    return data;
  }
}
