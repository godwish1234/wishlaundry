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

  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;

  void initialize() async {
    user = FirebaseAuth.instance.currentUser;

    await updateDate(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _appStateManager.completeLogout();
  }

  Future updateDate(DateTime startDate, DateTime endDate) async {
    _selectedStartDate = startDate;
    _selectedEndDate = endDate;
  }
}
