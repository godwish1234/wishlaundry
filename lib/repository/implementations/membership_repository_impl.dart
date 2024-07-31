import 'dart:convert';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishlaundry/repository/interfaces/membership_repository.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final CollectionReference memberData =
      FirebaseFirestore.instance.collection('membership');

  @override
  Stream<QuerySnapshot> getTransactionStream() {
    final transactionStream =
        memberData.orderBy('name', descending: false).snapshots();
    return transactionStream;
  }

  @override
  Stream<QuerySnapshot> searchStream(String searchString) {
    final transactionStream = memberData
        .where("name", isGreaterThanOrEqualTo: searchString)
        .where("name", isLessThanOrEqualTo: "$searchString\uf7ff")
        .orderBy('name', descending: false)
        .snapshots();
    return transactionStream;
  }

  @override
  Future addMember(String name, int balance, int type, List transactions,
      String dateCreated, String dateExpiry) async {
    return memberData.add({
      'name': name,
      'balance': balance,
      'type': type,
      'transactions': transactions,
      'dateCreated': dateCreated,
      'dateExpiry': dateExpiry
    });
  }

  // UPDATE: update member
  @override
  Future<void> updateMemberData(String docID, int balance, List transactions) {
    print(transactions);
    // String jsonList = jsonEncode(transactions);
    return memberData
        .doc(docID)
        .update({'balance': balance, 'transactions': transactions});
  }

  @override
  Future<void> delete(String docID) {
    return memberData.doc(docID).delete();
  }

  @override
  Future<void> getData(String docID) {
    return memberData.doc(docID).get();
  }
}
