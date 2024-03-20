import 'package:flutter/material.dart';
import 'package:tabapplication/data/base_api_client.dart';
import 'package:tabapplication/model/mjpt/version_check_response.dart';


class VersioCheckRepository {
  final _baseClient = BaseApiClient();
  
  Future<VersionCheckResponse?> versionCheckDetails(
      BuildContext context, String Url) async {
    final versionCheckResponse =
        await _baseClient.getCall(context, Url);
    return VersionCheckResponse.fromJson(versionCheckResponse);
  }
}
