import 'package:isar/isar.dart';
import 'package:wishlaundry/constants/isar_configuration.dart';
import 'package:wishlaundry/dependency_injection/service_locator.dart';
class WishLaundryInit {

  static Future launchInit(String? applicationDocumentsDirectoryPath) async {

    List<CollectionSchema> isarCollections = [];
    isarCollections.addAll(IsarConfiguration.isarSchemas);

    var isar = await Isar.open(
        schemas: isarCollections,
        directory: applicationDocumentsDirectoryPath,
        inspector: false);

    await setupServiceLocator(
      applicationDocumentsDirectoryPath,
      isar,
    );
  }
}
