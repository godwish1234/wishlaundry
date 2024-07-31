import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/services/interfaces/membership_service.dart';

class MembershipViewModel extends BaseViewModel {
  final membershipService = GetIt.instance.get<MembershipService>();
  final _appStateManager = GetIt.I<AppStateManager>();

  User? user;

  void initialize() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future addMember(String name, int balance, int type) async {
    List transactions = [];
    transactions.add({
      'price': balance,
      'product': "isi saldo",
      'timestamp': Timestamp.now()
    });
    await membershipService.addMember(
        name,
        balance,
        type,
        transactions,
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        DateFormat('dd/MM/yyyy HH:mm')
            .format(DateTime.now().add(const Duration(days: 90))));
    notifyListeners();
  }

  Future updateMemberData(String docID, int balance, int price, String product,
      List transactions) async {
    transactions.add(
        {'price': price, 'product': product, 'timestamp': Timestamp.now()});
    await membershipService.updateMemberData(
      docID,
      balance,
      transactions,
    );
    notifyListeners();
  }

  Future deleteMember(docId) async {
    await membershipService.delete(docId);
    notifyListeners();
  }

  void onListClicked(String docID) {
    _appStateManager.showMembershipDetailPage(docID);
    notifyListeners();
  }
}
