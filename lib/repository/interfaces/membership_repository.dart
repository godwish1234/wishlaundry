import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MembershipRepository {
  Stream<QuerySnapshot> getTransactionStream();
  Stream<QuerySnapshot> searchStream(String searchString);
  Future addMember(String name, int balance, int type, List transactions,
      String dateCreated, String dateExpiry);
  Future<void> delete(String docID);
  Future<void> updateMemberData(String docID, int balance, List transaction, String dateCreated, String dateExpiry);
  Future<void> getData(String docID);
}
