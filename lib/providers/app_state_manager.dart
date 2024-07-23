import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/services/interfaces/user_settings_service.dart';

class AppStateManager extends ChangeNotifier {
  final _userSettingsService = GetIt.I<UserSettingsService>();

  var _currentScreen = AppLinkLocationKeys.home;
  String get currentScreen => _currentScreen;

  var _loggedIn = false;
  bool get isLoggedIn => _loggedIn;
  set setIsLoggedIn(isLoggedIn) {
    _loggedIn = isLoggedIn;
  }

  bool get homePage => _currentScreen == AppLinkLocationKeys.home;

  bool get isDarkMode => _userSettingsService.isDarkMode();

  ThemeMode get mode => isDarkMode == true ? ThemeMode.dark : ThemeMode.light;

  Locale _locale = const Locale("id");
  Locale get locale => _locale;

  bool _isRefresh = false;
  bool get isRefresh => _isRefresh;

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
  }

  // Future toggleMode() async {
  //   _ptfiConopsTelemetryService.trackEvent('Switch Dark Mode');
  //   await _userSettingsService.setDarkMode();
  //   notifyListeners();
  // }

  Future completeLogin() async {
    _loggedIn = true;
    _currentScreen = AppLinkLocationKeys.home;
    notifyListeners();
  }

  void completeLogout() {
    _currentScreen = AppLinkLocationKeys.login;
    _loggedIn = false;
    notifyListeners();
  }

  void showHomePage() {
    _currentScreen = AppLinkLocationKeys.home;
    notifyListeners();
  }

  DateTime getTimeNow() {
    DateTime dt = DateTime.now();
    return dt;
  }
}
