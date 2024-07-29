import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/services/interfaces/membership_service.dart';

class MembershipViewModel extends BaseViewModel {
  final membershipService = GetIt.instance.get<MembershipService>();

  User? user;

  void initialize() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future addMember(String name, int balance, int type) async {
    await membershipService.addMember(
        name,
        balance,
        type,
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        DateFormat('dd/MM/yyyy HH:mm')
            .format(DateTime.now().add(const Duration(days: 90))));
    notifyListeners();
  }

  Future deleteMember(docId) async {
    await membershipService.delete(docId);
    notifyListeners();
  }
}
