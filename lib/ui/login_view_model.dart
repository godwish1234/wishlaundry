import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/services/interfaces/authentication_service.dart';
import 'package:wishlaundry/services/interfaces/profile_service.dart';

class LoginViewModel extends BaseViewModel {
  final _auth = GetIt.I<AuthenticationService>();
  late final AppStateManager _appStateManager;
  late final AnimationController _fadeTransitionController;
  late final Animation<double> fadeTransitionAnimation;
  late final ProfileService _profileService;

  LoginViewModel(TickerProviderStateMixin<StatefulWidget> loginView) {
    _appStateManager = GetIt.instance.get<AppStateManager>();
    _profileService = GetIt.instance<ProfileService>();

    _fadeTransitionController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: loginView,
    )..repeat(reverse: true);

    fadeTransitionAnimation = CurvedAnimation(
      parent: _fadeTransitionController,
      curve: Curves.easeIn,
    );
  }

  initialize() async {}

  void signIn(String phoneno, String password) async {
    User? user = await _auth.signInWithEmailAndPassword(phoneno, password);

    if (user != null) {
      await _profileService.initialize(forceRefresh: true);
      await _appStateManager.completeLogin();
    } else {
      print('error occurred');
    }
  }
  
  @override
  void dispose() {
    _fadeTransitionController.dispose();
    super.dispose();
  }
}
