import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<dynamic> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String versionValue = packageInfo.version;
  debugPrint("version number :::${versionValue}");
  return versionValue;
}
