import 'package:flutter/material.dart';
import 'package:tabapplication/data/base_api_client.dart';
import 'package:tabapplication/model/mjpt/get_attendence_info_response.dart';


class AttendanceRepository {
  final _baseClient = BaseApiClient();
  
  Future<GetAttendanceInfoResponse?> attendanceInfoDetails(
      BuildContext context, String Url) async {
    final attendanceResponse =
        await _baseClient.getCall(context, Url);
    return GetAttendanceInfoResponse.fromJson(attendanceResponse);
  }
}
