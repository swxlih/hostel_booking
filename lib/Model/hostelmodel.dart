import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Hostelmodel> hostelmodelFromJson(String str) =>
    List<Hostelmodel>.from(json.decode(str).map((x) => Hostelmodel.fromJson(x)));

String hostelmodelToJson(List<Hostelmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hostelmodel {
  String? hostelid;
  Amenities? amenities;
  Timestamp? createdAt;
  String? address;
  String? ownerName;
  String? phone;
  String? price;
  String? hostelName;
  List<String>? imageUrl;
  String? availableBeds;
  String? location;
  String? place;
  String? discription;
  String? selectedgenter;
  String? selecteddormetry;
  String? hostelerid;
  int? status;
  List<String>? searchKeywords;

  Hostelmodel({
    this.hostelid,
    this.amenities,
    this.createdAt,
    this.address,
    this.ownerName,
    this.phone,
    this.price,
    this.hostelName,
    this.imageUrl,
    this.availableBeds,
    this.location,
    this.place,
    this.discription,
    this.selectedgenter,
    this.selecteddormetry,
    this.hostelerid,
    this.status,
    this.searchKeywords,
  });

  /// 🔹 Create a model from JSON / Firestore Map
  factory Hostelmodel.fromJson(Map<String, dynamic> json) => Hostelmodel(
        amenities: json["amenities"] == null
            ? null
            : Amenities.fromJson(json["amenities"]),
        createdAt: json["createdAt"] is Timestamp
            ? json["createdAt"]
            : json["createdAt"] != null
                ? Timestamp.fromMillisecondsSinceEpoch(json["createdAt"])
                : null,
        address: json["address"],
        hostelid: json["hostelid"],
        ownerName: json["ownerName"],
        phone: json["phone"],
        price: json["price"].toString(),
        hostelName: json["hostelName"],
         imageUrl:json["imageUrl"] !=null?List<String>.from(json["imageUrl"].map((x) => x)):[],
     
        availableBeds: json["availableBeds"].toString(),
        location: json["location"],
        place: json["place"],
        discription: json["discription"],
        selectedgenter: json["selectedgenter"],
        selecteddormetry: json["selecteddormetry"],
        hostelerid: json["hostelerId"],
        status: json["status"],
        searchKeywords: List<String>.from(json['searchKeywords'] ?? []),

      );


  Map<String, dynamic> toJson() => {
        "amenities": amenities?.toJson(),
        "hostelid":hostelid,
        "createdAt": createdAt,
        "address": address,
        "ownerName": ownerName,
        "phone": phone,
        "price": price,
        "hostelName": hostelName,
         "imageUrl": imageUrl!=null? List<dynamic>.from(imageUrl!.map((x) => x)):[],
        
        "availableBeds": availableBeds,
        "location": location,
        "place":place,
        "discription":discription,
        "selectedgenter":selectedgenter,
        "selecteddormetry":selecteddormetry,
        "hostelerId":hostelerid,
        "status":status,
        'searchKeywords': searchKeywords,
      };
}

class Amenities {
  bool? parking;
  bool? attachedBathroom;
  bool? furnished;
  bool? locker;
  bool? food;

  Amenities({
    this.parking,
    this.attachedBathroom,
    this.furnished,
    this.locker,
    this.food,
  });

  factory Amenities.fromJson(Map<String, dynamic> json) => Amenities(
        parking: json["parking"],
        attachedBathroom: json["attachedBathroom"],
        furnished: json["furnished"],
        locker: json["locker"],
        food: json["food"],
      );

  Map<String, dynamic> toJson() => {
        "parking": parking,
        "attachedBathroom": attachedBathroom,
        "furnished": furnished,
        "locker": locker,
        "food": food,
      };
}
