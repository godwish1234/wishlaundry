import 'package:isar/isar.dart';
import 'package:wishlaundry/enums/language.dart';

part 'user_setting.g.dart';

@Collection()
class UserSetting {
  @Id()
  int id = Isar.autoIncrement;
  bool isNewUser;
  String? name;
  String? phoneno;
  String? languageId;
  DateTime utcLastUpdated;
  bool? isDarkMode;

  UserSetting(
      {this.isNewUser = false,
      this.name,
      this.phoneno,
      this.languageId,
      required this.utcLastUpdated,
      this.isDarkMode});

  factory UserSetting.empty() => UserSetting(
      languageId: Language.bahasa.id,
      utcLastUpdated: DateTime.now().toUtc());
}
