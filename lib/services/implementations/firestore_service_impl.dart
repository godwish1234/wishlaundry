import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/repository/interfaces/firestore_repository.dart';

import '../services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceImpl implements FirestoreService {
  //get collections of transaction
  final CollectionReference transaction =
      FirebaseFirestore.instance.collection('transaction');
  final appState = GetIt.instance<AppStateManager>();

  final _firestoreRepository = GetIt.instance<FirestoreRepository>();

  @override
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      appState.showHomePage();
    }
    return firebaseApp;
  }

  @override
  Future<void> addtransaction(
      String name,
      Timestamp date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount) {
    return _firestoreRepository.addtransaction(name, date, clothesCount,
        underpantsCount, brasCount, socksCount, othersCount, totalCount);
  }

  @override
  Stream<QuerySnapshot> getTransactionStream(Timestamp startDate, Timestamp endDate) {
    return _firestoreRepository.getTransactionStream(startDate, endDate);
  }

  @override
  Stream<QuerySnapshot> searchStream(String searchString) {
    return _firestoreRepository.searchStream(searchString);
  }

  // UPDATE: update transactions
  @override
  Future<void> updatetransaction(
      String docID, int status, String step, String totalCount) {
    return _firestoreRepository.updatetransaction(
        docID, status, step, totalCount);
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
    return _firestoreRepository.forceUpdate(
        docID,
        status,
        step,
        clothesCount,
        underpantsCount,
        brasCount,
        socksCount,
        othersCount,
        totalCount,
        bypass);
  }

  @override
  Future<void> updatetransactionIncorrectInput(String docID, int attempt) {
    return _firestoreRepository.updatetransactionIncorrectInput(docID, attempt);
  }

  @override
  Future<void> delete(String docID) {
    return _firestoreRepository.delete(docID);
  }
}
