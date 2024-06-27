import 'package:flutter/material.dart';
import 'package:wishlaundry/models/localStorage/user_setting.dart';

abstract class UserSettingsProvider extends ChangeNotifier {
  UserSetting get userSetting;
}
