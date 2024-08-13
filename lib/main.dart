import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:wishlaundry/enums/language.dart';
import 'package:wishlaundry/firebase_options.dart';
import 'package:wishlaundry/initialization/wish_laundry_init.dart';
import 'package:wishlaundry/localizations/codegen_loader.g.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/routing/app_route_parser.dart';
import 'package:wishlaundry/routing/app_router.dart';

import 'providers/interfaces/user_settings_provider.dart';
import 'services/interfaces/authentication_service.dart';
import 'package:path_provider/path_provider.dart';

var initError = false;

void main() {
  runZonedGuarded(
    () async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await EasyLocalization.ensureInitialized();
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
        // final notificationService = NotificationServiceImpl();
        // await notificationService.listenNotifications();

        Directory? applicationDocumentsDirectory;

        if (!kIsWeb) {
          // if platform android/ios, get different doc dir
          applicationDocumentsDirectory =
              await getApplicationDocumentsDirectory();
        }

        await WishLaundryInit.launchInit(applicationDocumentsDirectory?.path);

        final auth = GetIt.instance<AuthenticationService>();
        final appState = GetIt.instance<AppStateManager>();

        final isAlreadyLoggedIn = await auth.isAlreadyLoggedIn();
        if (isAlreadyLoggedIn) {
          // var profileSvc = GetIt.I<ProfileService>();
          // profileSvc.initialize();

          // this will tell router to directly navigate to home page
          await appState.completeLogin();
        } else {
          // await preference.clearAccessToken();
          appState.setIsLoggedIn = false;
        }

        return runApp(EasyLocalization(
            path: 'assets/translations',
            supportedLocales: [
              Language.bahasa.toLocale(),
              // Language.englishUS.toLocale()
            ],
            assetLoader: const CodegenLoader(),
            child: const WishLaundry()));
      } catch (e) {
        initError = true;
        rethrow;
      }
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint(
            "ERROR main.dart (initError: $initError): ${error.toString()}");
      }

      // var telemetry = GetIt.instance<PtfiConopsTelemetryService>();
      // telemetry.trackError(
      //   isFatal: initError,
      //   error: error,
      //   trace: stack,
      //   step: initError
      //       ? "Initialize Application"
      //       : "runZonedGuarded (main.dart)",
      // );
    },
  );
}

class WishLaundry extends StatefulWidget {
  const WishLaundry({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WishLaundryState();
}

class _WishLaundryState extends State<WishLaundry> with WidgetsBindingObserver {
  final _scaffoldMessengerStateKey = GlobalKey<ScaffoldMessengerState>();
  final _routeParser = AppRouteParser();
  late AppRouter _appRouter;

  final _appStateManager = GetIt.instance<AppStateManager>();

  @override
  void initState() {
    _appRouter = AppRouter();
    super.initState();

    // WidgetsBinding.instance
    //     .addObserver(LifecycleEventHandler(resumeCallBack: onResume));
  }

  // Future onResume() async {
  //   if (_appStateManager.isLoggedIn) {
  //     _appStateManager.syncData(abortPrevious: false);
  //   } else {
  //     await _appUpdateProvider.checkForUpdates();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ColorScheme appColors = ColorScheme.fromSeed(seedColor: Color(0xFF0b39a7));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _appStateManager),
        ChangeNotifierProvider(
          create: (ctx) => GetIt.I<UserSettingsProvider>(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Consumer<AppStateManager>(
          builder: (BuildContext context, value, Widget? child) {
            return MaterialApp.router(
              locale: context.locale,
              routeInformationParser: _routeParser,
              routerDelegate: _appRouter,
              scaffoldMessengerKey: _scaffoldMessengerStateKey,
              title: "Wish Laundry POS",
              themeMode: value.mode,
              theme: ThemeData(
                // useMaterial3: true,
                colorScheme: appColors, //<--this
                textTheme: TextTheme(
                    titleLarge:
                        TextStyle(color: appColors.primary)), //<--and this
              ),
              backButtonDispatcher: RootBackButtonDispatcher(),
              supportedLocales: context.supportedLocales,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
            );
          },
        ),
      ),
    );
  }
}
