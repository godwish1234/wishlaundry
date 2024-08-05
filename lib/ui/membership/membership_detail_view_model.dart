import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/services/interfaces/membership_service.dart';

class MembershipDetailViewModel extends BaseViewModel {
  final _appStateManager = GetIt.I<AppStateManager>();
  final _membershipService = GetIt.I<MembershipService>();
  DocumentSnapshot? document;

  // Map<String, dynamic>? data;

  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;

  String docId = '';

  void initialize() async {
    setBusy(true);
    docId = _appStateManager.docID;
    document = await getMemberData(docId);

    _data = document?.data() as Map<String, dynamic>;

    notifyListeners();
    setBusy(false);
  }

  Future getMemberData(docId) async {
    return await _membershipService.getData(docId);
  }

  Future<void> refreshData() async {
    document = await getMemberData(docId);
    _data = document?.data() as Map<String, dynamic>;

    notifyListeners();
  }

  Future<void> updateMemberData(
      int initialBalance, int topupBalance, int price, int product, List transactions, String dateCreated, String dateExpiry, int type) async {
    if (product == 1) {
      transactions.clear();
      transactions
          .add({'price': initialBalance, 'product': 3, 'timestamp': Timestamp.now()});
      transactions.add(
          {'price': price, 'product': product, 'timestamp': Timestamp.now()});
    } else {
      transactions.add(
          {'price': price, 'product': product, 'timestamp': Timestamp.now()});
    }

    await _membershipService.updateMemberData(docId, topupBalance, transactions, dateCreated, dateExpiry, type);
    document = await getMemberData(docId);
    _data = document?.data() as Map<String, dynamic>;
    notifyListeners();
  }
}
