import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body =>
      'Hey there! A new version of {{appName}} is available!😎 Version {{currentAppStoreVersion}} is available and your current version is  {{currentInstalledVersion}}';
}
