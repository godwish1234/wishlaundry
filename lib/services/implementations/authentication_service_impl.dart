import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wishlaundry/localizations/locale_keys.g.dart';
import 'package:wishlaundry/services/interfaces/authentication_service.dart';

class AuthenticationServiceImpl implements AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User?> signInWithEmailAndPassword(String phoneno, String password) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: phoneno, password: password);
      return credential.user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: LocaleKeys.login_validation.tr(),
          webPosition: "center",
          toastLength: Toast.LENGTH_LONG);
    }
    return null;
  }

  @override
  Future<bool> isAlreadyLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
