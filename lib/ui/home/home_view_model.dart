import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/services/services.dart';

class HomeViewModel extends BaseViewModel {
  static final _appStateManager = GetIt.instance.get<AppStateManager>();
  // firestore
  static final firestoreService = GetIt.instance.get<FirestoreService>();
  User? user;

  void initialize() async {
    user = FirebaseAuth.instance.currentUser;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _appStateManager.completeLogout();
  }
}
