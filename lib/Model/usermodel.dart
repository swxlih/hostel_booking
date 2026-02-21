// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
    String? uid;
    String? name;
    String? role;
    String? address;
    String? email;
    String? number;
    String? ratepermonth;

    Usermodel({
        this.uid,
        this.name,
        this.role,
        this.address,
        this.email,
        this.number,
        this.ratepermonth,
    });

    factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        uid: json["uid"],
        name: json["name"],
        role: json["role"],
        address: json["address"],
        email: json["email"],
        number: json["number"],
        ratepermonth: json["ratepermonth"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "role": role,
        "address": address,
        "email": email,
        "number": number,
        "ratepermonth": ratepermonth,
    };
}





