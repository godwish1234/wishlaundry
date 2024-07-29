import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MembershipRepository {
  Stream<QuerySnapshot> getTransactionStream();
  Future addMember(String name, int balance, int type, String dateCreated,  String dateExpiry);
  Future<void> delete(String docID);
}
