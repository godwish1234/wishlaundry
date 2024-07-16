import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class FirestoreService {
  Future<FirebaseApp> initializeFirebase();
  Future<void> addNote(
      String name,
      String date,
      int clothesCount,
      int underpantsCount,
      int brasCount,
      int socksCount,
      int othersCount,
      String totalCount);
  Stream<QuerySnapshot> getNotesStream();
  Stream<QuerySnapshot> searchStream(String searchString);
  Future<void> updateNote(
      String docID, int status, String step, String totalCount);
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
      int bypass);
  Future<void> updateNoteIncorrectInput(String docID, int attempt);
  Future<void> delete(String docID);
}
