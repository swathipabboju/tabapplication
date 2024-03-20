
class VersionCheckResponse {
  bool? success;
  String? statusMessage;
  int? statusCode;
  VersionCheckData? data;
  bool? paginated;

  VersionCheckResponse({this.success, this.statusMessage, this.statusCode, this.data, this.paginated});

  VersionCheckResponse.fromJson(Map<String, dynamic> json) {
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
      data = json["data"] == null ? null : VersionCheckData.fromJson(json["data"]);
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

class VersionCheckData {
  String? versionNo;
  String? lastupdatedDate;
  String? maxTimeChk;
  String? accountDeleteFlag;

  VersionCheckData({this.versionNo, this.lastupdatedDate, this.maxTimeChk, this.accountDeleteFlag});

  VersionCheckData.fromJson(Map<String, dynamic> json) {
    if(json["version_no"] is String) {
      versionNo = json["version_no"];
    }
    if(json["lastupdated_date"] is String) {
      lastupdatedDate = json["lastupdated_date"];
    }
    if(json["max_time_chk"] is String) {
      maxTimeChk = json["max_time_chk"];
    }
    if(json["account_delete_flag "] is String) {
      accountDeleteFlag = json["account_delete_flag "];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["version_no"] = versionNo;
    _data["lastupdated_date"] = lastupdatedDate;
    _data["max_time_chk"] = maxTimeChk;
    _data["account_delete_flag "] = accountDeleteFlag;
    return _data;
  }
}