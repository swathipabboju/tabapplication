import 'package:flutter/material.dart';
import 'package:tabapplication/data/base_api_client.dart';
import 'package:tabapplication/model/mjpt/masterdata_response.dart';


class MasterDataRepository {
  final _baseClient = BaseApiClient();
  
  Future<MasterDataResponse?> masterDataDetails(
      BuildContext context, String Url) async {
    final masterDataResponse =
        await _baseClient.getCall(context, Url);
    return MasterDataResponse.fromJson(masterDataResponse);
  }
}
