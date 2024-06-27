import 'package:wishlaundry/models/localStorage/user_setting.dart';

abstract class UserSettingsRepository {
  Future<UserSetting> getUserSetting(String? emailAddress);
  Future upsertUserSetting(UserSetting userSetting);
}
