import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';

import '../services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceImpl implements FirestoreService {
  //get collections of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('transaction');
  final appState = GetIt.instance<AppStateManager>();

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
  // CREATE: add a new note
  Future<void> addNote(
      String name,
      String date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount) {
    return notes.add({
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
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes.orderBy('date', descending: true).snapshots();
    return notesStream;
  }

  @override
  Stream<QuerySnapshot> searchStream(String searchString) {
    final notesStream = notes
        .where("name", isGreaterThanOrEqualTo: searchString)
        .where("name", isLessThanOrEqualTo: "$searchString\uf7ff")
        .orderBy('name')
        .orderBy('date', descending: true)
        .snapshots();
    return notesStream;
  }

  // UPDATE: update transactions
  @override
  Future<void> updateNote(
      String docID, int status, String step, String totalCount) {
    return notes.doc(docID).update({
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
    return notes.doc(docID).update({
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
  Future<void> updateNoteIncorrectInput(String docID, int attempt) {
    return notes.doc(docID).update({
      'attempt': attempt,
    });
  }
}
