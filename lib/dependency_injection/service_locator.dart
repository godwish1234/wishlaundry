import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/providers/implementations/user_settings_provider_impl.dart';
import 'package:wishlaundry/providers/interfaces/user_settings_provider.dart';
import 'package:wishlaundry/repository/implementations/membership_repository_impl.dart';
import 'package:wishlaundry/repository/implementations/user_settings_repository_impl.dart';
import 'package:wishlaundry/repository/interfaces/firestore_repository.dart';
import 'package:wishlaundry/repository/interfaces/membership_repository.dart';
import 'package:wishlaundry/repository/interfaces/user_settings_repository.dart';
import 'package:wishlaundry/services/implementations/membership_service_impl.dart';
import 'package:wishlaundry/services/interfaces/membership_service.dart';
import 'package:wishlaundry/services/services.dart';

import '../repository/implementations/firestore_repository_impl.dart';

final GetIt serviceLocator = GetIt.instance;

Future setupServiceLocator(
  String? applicationDocumentsDirectoryPath,
  Isar isar,
) async {
  // Providers
  serviceLocator.registerSingleton<UserSettingsRepository>(
    UserSettingsRepositoryImpl(isar: isar),
  );
  var userSettingSvc = UserSettingsServiceImpl();
  await Future.wait([
    userSettingSvc.initialize(),
  ]);
  serviceLocator.registerSingleton<UserSettingsService>(userSettingSvc);

  serviceLocator
      .registerSingleton<UserSettingsProvider>(UserSettingsProviderImpl());
  serviceLocator.registerSingleton<AppStateManager>(AppStateManager());
  serviceLocator
      .registerSingleton<AuthenticationService>(AuthenticationServiceImpl());

  // Un-register internet connectivity provider from FMI core
  // then register our custom provider.
  // Repositories
  serviceLocator
      .registerSingleton<FirestoreRepository>(FirestoreRepositoryImpl());
  serviceLocator
      .registerSingleton<MembershipRepository>(MembershipRepositoryImpl());
  // Services
  serviceLocator.registerSingleton<ProfileService>(ProfileServiceImpl());
  serviceLocator
      .registerSingleton<NotificationService>(NotificationServiceImpl());
  serviceLocator.registerSingleton<FirestoreService>(FirestoreServiceImpl());
  serviceLocator.registerSingleton<MembershipService>(MembershipServiceImpl());
}
