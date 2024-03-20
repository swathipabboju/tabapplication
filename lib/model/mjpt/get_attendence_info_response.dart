
class GetAttendanceInfoResponse {
  bool? success;
  String? statusMessage;
  int? statusCode;
  AttendanceInfoData? data;
  bool? paginated;

  GetAttendanceInfoResponse({this.success, this.statusMessage, this.statusCode, this.data, this.paginated});

  GetAttendanceInfoResponse.fromJson(Map<String, dynamic> json) {
    if(json["success"] is bool) {
      success = json["success"];
    }
    if(json["status_Message"] is String) {
      statusMessage = json["status_Message"];
    }
    if(json["status_Code"] is int) {
      statusCode = json["status_Code"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : AttendanceInfoData.fromJson(json["data"]);
    }
    if(json["paginated"] is bool) {
      paginated = json["paginated"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["status_Message"] = statusMessage;
    _data["status_Code"] = statusCode;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    _data["paginated"] = paginated;
    return _data;
  }
}

class AttendanceInfoData {
  String? finaldayout;
  String? totalWorkHours;
  List<AttendanceLog>? attendanceLog;
  String? lastWorkingDay;
  AttendanceInfo? attendanceInfo;
  List<dynamic>? workLocList;

  AttendanceInfoData({this.finaldayout, this.totalWorkHours, this.attendanceLog, this.lastWorkingDay, this.attendanceInfo, this.workLocList});

  AttendanceInfoData.fromJson(Map<String, dynamic> json) {
    if(json["finaldayout"] is String) {
      finaldayout = json["finaldayout"];
    }
    if(json["total_work_hours"] is String) {
      totalWorkHours = json["total_work_hours"];
    }
    if(json["attendance_log"] is List) {
      attendanceLog = json["attendance_log"] == null ? null : (json["attendance_log"] as List).map((e) => AttendanceLog.fromJson(e)).toList();
    }
    if(json["LastWorkingDay"] is String) {
      lastWorkingDay = json["LastWorkingDay"];
    }
    if(json["attendance_info"] is Map) {
      attendanceInfo = json["attendance_info"] == null ? null : AttendanceInfo.fromJson(json["attendance_info"]);
    }
    if(json["WorkLocList"] is List) {
      workLocList = json["WorkLocList"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["finaldayout"] = finaldayout;
    _data["total_work_hours"] = totalWorkHours;
    if(attendanceLog != null) {
      _data["attendance_log"] = attendanceLog?.map((e) => e.toJson()).toList();
    }
    _data["LastWorkingDay"] = lastWorkingDay;
    if(attendanceInfo != null) {
      _data["attendance_info"] = attendanceInfo?.toJson();
    }
    if(workLocList != null) {
      _data["WorkLocList"] = workLocList;
    }
    return _data;
  }
}

class AttendanceInfo {
  String? inStatusAttendance;
  String? markAttendanceReason;
  String? markAttendance;

  AttendanceInfo({this.inStatusAttendance, this.markAttendanceReason, this.markAttendance});

  AttendanceInfo.fromJson(Map<String, dynamic> json) {
    if(json["in_status_attendance"] is String) {
      inStatusAttendance = json["in_status_attendance"];
    }
    if(json["mark_attendance_reason"] is String) {
      markAttendanceReason = json["mark_attendance_reason"];
    }
    if(json["mark_attendance"] is String) {
      markAttendance = json["mark_attendance"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["in_status_attendance"] = inStatusAttendance;
    _data["mark_attendance_reason"] = markAttendanceReason;
    _data["mark_attendance"] = markAttendance;
    return _data;
  }
}

class AttendanceLog {
  String? outTime;
  String? inWorklocation;
  String? inLongitude;
  String? inOfficePremises;
  String? inIsapproved;
  String? inLatitude;
  String? outOfficePremises;
  String? outLongitude;
  String? duration;
  String? inTime;
  String? outWorklocation;
  String? outLatitude;
  String? outIsapproved;

  AttendanceLog({this.outTime, this.inWorklocation, this.inLongitude, this.inOfficePremises, this.inIsapproved, this.inLatitude, this.outOfficePremises, this.outLongitude, this.duration, this.inTime, this.outWorklocation, this.outLatitude, this.outIsapproved});

  AttendanceLog.fromJson(Map<String, dynamic> json) {
    if(json["out_time"] is String) {
      outTime = json["out_time"];
    }
    if(json["in_worklocation"] is String) {
      inWorklocation = json["in_worklocation"];
    }
    if(json["in_longitude"] is String) {
      inLongitude = json["in_longitude"];
    }
    if(json["in_office_premises"] is String) {
      inOfficePremises = json["in_office_premises"];
    }
    if(json["in_isapproved"] is String) {
      inIsapproved = json["in_isapproved"];
    }
    if(json["in_latitude"] is String) {
      inLatitude = json["in_latitude"];
    }
    if(json["out_office_premises"] is String) {
      outOfficePremises = json["out_office_premises"];
    }
    if(json["out_longitude"] is String) {
      outLongitude = json["out_longitude"];
    }
    if(json["duration"] is String) {
      duration = json["duration"];
    }
    if(json["in_time"] is String) {
      inTime = json["in_time"];
    }
    if(json["out_worklocation"] is String) {
      outWorklocation = json["out_worklocation"];
    }
    if(json["out_latitude"] is String) {
      outLatitude = json["out_latitude"];
    }
    if(json["out_isapproved"] is String) {
      outIsapproved = json["out_isapproved"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["out_time"] = outTime;
    _data["in_worklocation"] = inWorklocation;
    _data["in_longitude"] = inLongitude;
    _data["in_office_premises"] = inOfficePremises;
    _data["in_isapproved"] = inIsapproved;
    _data["in_latitude"] = inLatitude;
    _data["out_office_premises"] = outOfficePremises;
    _data["out_longitude"] = outLongitude;
    _data["duration"] = duration;
    _data["in_time"] = inTime;
    _data["out_worklocation"] = outWorklocation;
    _data["out_latitude"] = outLatitude;
    _data["out_isapproved"] = outIsapproved;
    return _data;
  }
}