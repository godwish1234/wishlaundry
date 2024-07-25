import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wishlaundry/providers/app_state_manager.dart';
import 'package:wishlaundry/providers/implementations/user_settings_provider_impl.dart';
import 'package:wishlaundry/providers/interfaces/user_settings_provider.dart';
import 'package:wishlaundry/repository/implementations/user_settings_repository_impl.dart';
import 'package:wishlaundry/repository/interfaces/user_settings_repository.dart';
import 'package:wishlaundry/services/services.dart';

final GetIt serviceLocator = GetIt.instance;

Future setupServiceLocator(
  String? applicationDocumentsDirectoryPath,
  Isar isar,
) async {
  serviceLocator
      .registerSingleton<AuthenticationService>(AuthenticationServiceImpl());

  serviceLocator.registerSingleton<UserSettingsRepository>(
    UserSettingsRepositoryImpl(isar: isar),
  );
  var userSettingSvc = UserSettingsServiceImpl();
  await Future.wait([
    userSettingSvc.initialize(),
  ]);
  serviceLocator.registerSingleton<UserSettingsService>(userSettingSvc);

  // Providers
  serviceLocator.registerSingleton<AppStateManager>(AppStateManager());
  serviceLocator
      .registerSingleton<UserSettingsProvider>(UserSettingsProviderImpl());
  // Un-register internet connectivity provider from FMI core
  // then register our custom provider.
  // Repositories
  // Services
  serviceLocator.registerSingleton<ProfileService>(ProfileServiceImpl());
  serviceLocator
      .registerSingleton<NotificationService>(NotificationServiceImpl());
}
