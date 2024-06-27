import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/routing/app_link.dart';
import 'package:wishlaundry/routing/app_link_location_keys.dart';
import 'package:wishlaundry/ui/home/home_view.dart';
import 'package:wishlaundry/ui/login_view.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // final appUpdateProvider = GetIt.instance<AppUpdateProvider>();
  final appStateManager = GetIt.instance<AppStateManager>();

  AppRouter() : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    // appUpdateProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isLoggedIn)
          LoginView.page()
        else ...[
          HomeView.page(),
        ],
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  /// Upon app state updates that affect url, here we will
  /// need to provide a corresponding AppLink object
  /// that the RouteInformationParser utilizes
  AppLink getCurrentPath() {

    if (!appStateManager.isLoggedIn) {
      return AppLink(
        locationKey: AppLinkLocationKeys.login,
        realPath: AppLinkLocationKeys.login,
      );
    }
    if (appStateManager.homePage) {
      return AppLink(
          locationKey: AppLinkLocationKeys.home,
          realPath: AppLinkLocationKeys.home);
    }

    return AppLink(
      locationKey: appStateManager.currentScreen,
      realPath: appStateManager.currentScreen,
    );
  }

  /// Upon a URL update by the browser, this method will be called
  /// and provide us with an AppLink object to inspect
  /// Utilizing the AppLink we can adjust application
  /// State if needed
  @override
  Future<void> setNewRoutePath(AppLink configuration) async {

    switch (configuration.locationKey) {
      case AppLinkLocationKeys.login:
        if (appStateManager.isLoggedIn) {
          appStateManager.showHomePage();
          break;
        }
        break;
    }
  }
}
