import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:wishlaundry/repository/interfaces/membership_repository.dart';
import 'package:wishlaundry/services/interfaces/membership_service.dart';

class MembershipServiceImpl implements MembershipService {
  final _membershipRepository = GetIt.instance<MembershipRepository>();

  @override
  Stream<QuerySnapshot> getTransactionStream() {
    return _membershipRepository.getTransactionStream();
  }

  @override
  Future addMember(String name, int balance, int type, String dateCreated,
      String dateExpiry) async {
    return _membershipRepository.addMember(
        name, balance, type, dateCreated, dateExpiry);
  }

  @override
  Future<void> delete(String docID) {
    return _membershipRepository.delete(docID);
  }
}
