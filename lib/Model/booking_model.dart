// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String? bookingid;
  Timestamp? createdAt;
  String? userid;
  String? hostelerid;
    String? hostelid;
    String? hostelname;
    String? hostelprice;
    String? bedcount;
    String? grandtotal;
    String? paymentstatus;
    int? status;
    String? hostlerId;
    Timestamp? checkindate;
    String? months;


    PaymentModel({
      this.bookingid,
      this.hostelerid,
      this.userid,
      this. createdAt,
        this.hostelid,
        this.hostelname,
        this.hostelprice,
        this.bedcount,
        this.grandtotal,
        this.paymentstatus,
        this.status,
        this.hostlerId,
        this.checkindate,
        this.months,
    });

    factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        bookingid: json["bookingid"],
        hostelerid: json["hostelerid"],
        userid:json["userid"],
        createdAt: json["createdAt"] is Timestamp
            ? json["createdAt"]
            : json["createdAt"] != null
                ? Timestamp.fromMillisecondsSinceEpoch(json["createdAt"])
                : null,
        hostelid: json["hostelid"],
        hostelname: json["hostelname"],
        hostelprice: json["hostelprice"],
        bedcount: json["bedcount"],
        grandtotal: json["grandtotal"],
        paymentstatus: json["paymentstatus"],
        status: json["status"],
        hostlerId: json["hostelerId"],
        checkindate: json["checkindate"] is Timestamp
            ? json["checkindate"]
            : json["checkindate"] != null
                ? Timestamp.fromMillisecondsSinceEpoch(json["checkindate"])
                : null,
        months: json["months"],
    );

    Map<String, dynamic> toJson() => {
        "bookingid":bookingid,
        "hostelerid":hostelerid,
        "userid":userid,
         "createdAt": createdAt,
        "hostelid": hostelid,
        "hostelname": hostelname,
        "hostelprice": hostelprice,
        "bedcount": bedcount,
        "grandtotal": grandtotal,
        "paymentstatus": paymentstatus,
        "status": status,
        "checkindate": checkindate,
        "months": months,
    };
}
