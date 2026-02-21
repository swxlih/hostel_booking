import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_booking/BookNow/address_model.dart';


class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference get _addressRef =>
      _firestore.collection('users').doc(userId).collection('addresses');

  /// ADD ADDRESS
  Future<void> addAddress(AddressModel address) async {
    await _addressRef.doc(address.id).set(address.toJson());
  }

  /// UPDATE ADDRESS
  Future<void> updateAddress(AddressModel address) async {
    await _addressRef.doc(address.id).update(address.toJson());
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(String addressId) async {
    await _addressRef.doc(addressId).delete();
  }

  /// SET DEFAULT ADDRESS
  Future<void> setDefault(String addressId) async {
    final batch = _firestore.batch();
    final snapshot = await _addressRef.get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    batch.update(_addressRef.doc(addressId), {'isDefault': true});
    await batch.commit();
  }

  /// GET ADDRESSES (STREAM)
  Stream<List<AddressModel>> getAddresses() {
    return _addressRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AddressModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
