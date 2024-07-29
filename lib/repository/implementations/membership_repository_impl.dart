import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishlaundry/repository/interfaces/membership_repository.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final CollectionReference transaction =
      FirebaseFirestore.instance.collection('membership');

  @override
  Stream<QuerySnapshot> getTransactionStream() {
    final transactionStream = transaction.snapshots();
    return transactionStream;
  }

  @override
  Future addMember(String name, int balance, int type, String dateCreated,
      String dateExpiry) async {
    return transaction.add({
      'name': name,
      'balance': balance,
      'type': type,
      'dateCreated': dateCreated,
      'dateExpiry': dateExpiry
    });
  }

  @override
  Future<void> delete(String docID) {
    return transaction.doc(docID).delete();
  }
}
