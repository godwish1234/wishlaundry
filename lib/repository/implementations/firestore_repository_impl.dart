import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishlaundry/repository/interfaces/firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final CollectionReference transaction =
      FirebaseFirestore.instance.collection('transaction');

  @override
  // CREATE: add a new transaction
  Future<void> addtransaction(
      String name,
      Timestamp date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount) {
    return transaction.add({
      'name': name,
      'date': date,
      'status': 1,
      'clothesCount': clothesCount,
      'underpantsCount': underpantsCount,
      'brasCount': brasCount,
      'socksCount': socksCount,
      'othersCount': othersCount,
      'initial': {
        'count': totalCount,
        'timestamp': Timestamp.now(),
      },
      'timestamp': Timestamp.now(),
      'attempt': 2
    });
  }

  // READ: get transactions from database
  @override
  Stream<QuerySnapshot> getTransactionStream(
      Timestamp startDate, Timestamp endDate, bool hideCompleted) {
    List status = [1, 2, 3];
    if (hideCompleted) {
      status = [1, 2];
    }
    final transactionStream = transaction
        .where('status', whereIn: status)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .snapshots();
    return transactionStream;
  }

  @override
  Stream<QuerySnapshot> searchStream(String searchString) {
    final transactionStream = transaction
        .where("name", isGreaterThanOrEqualTo: searchString)
        .where("name", isLessThanOrEqualTo: "$searchString\uf7ff")
        .orderBy('name')
        // .orderBy('date', descending: true)
        .snapshots();
    return transactionStream;
  }

  // UPDATE: update transactions
  @override
  Future<void> updatetransaction(
      String docID, int status, String step, String totalCount) {
    return transaction.doc(docID).update({
      'status': status,
      'timestamp': Timestamp.now(),
      step: {
        'count': totalCount,
        'timestamp': Timestamp.now(),
      },
      'attempt': 2
    });
  }

  @override
  Future<void> forceUpdate(
      String docID,
      int status,
      String step,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount,
      int bypass) {
    return transaction.doc(docID).update({
      'clothesCount': clothesCount,
      'underpantsCount': underpantsCount,
      'brasCount': brasCount,
      'socksCount': socksCount,
      'othersCount': othersCount,
      'status': status,
      'timestamp': Timestamp.now(),
      step: {
        'count': totalCount,
        'timestamp': Timestamp.now(),
      },
      'bypass': bypass,
      'attempt': 2
    });
  }

  @override
  Future<void> updatetransactionIncorrectInput(String docID, int attempt) {
    return transaction.doc(docID).update({
      'attempt': attempt,
    });
  }

  @override
  Future<void> delete(String docID) {
    return transaction.doc(docID).delete();
  }
}
