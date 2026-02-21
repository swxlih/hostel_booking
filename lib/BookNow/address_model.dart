class AddressModel{
  final String id;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String addressType;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.addressType,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel( 
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      addressType: json['addressType'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}