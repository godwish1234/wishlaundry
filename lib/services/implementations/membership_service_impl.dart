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
  Stream<QuerySnapshot> searchStream(String searchString) {
    return _membershipRepository.searchStream(searchString);
  }

  @override
  Future addMember(String name, int balance, int type, List transactions,
      String dateCreated, String dateExpiry) async {
    return _membershipRepository.addMember(
        name, balance, type, transactions, dateCreated, dateExpiry);
  }

  @override
  Future<void> updateMemberData(
      String docID, int balance, List transaction, String dateCreated, String dateExpiry) async {
    return _membershipRepository.updateMemberData(docID, balance, transaction, dateCreated, dateExpiry);
  }

  @override
  Future<void> delete(String docID) {
    return _membershipRepository.delete(docID);
  }

  @override
  Future<void> getData(String docID) {
    return _membershipRepository.getData(docID);
  }
}
