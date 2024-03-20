
class MasterDataResponse {
  bool? success;
  String? statusMessage;
  int? statusCode;
  List<MasterData>? data;
  bool? paginated;

  MasterDataResponse({this.success, this.statusMessage, this.statusCode, this.data, this.paginated});

  MasterDataResponse.fromJson(Map<String, dynamic> json) {
    if(json["success"] is bool) {
      success = json["success"];
    }
    if(json["status_Message"] is String) {
      statusMessage = json["status_Message"];
    }
    if(json["status_Code"] is int) {
      statusCode = json["status_Code"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => MasterData.fromJson(e)).toList();
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
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    _data["paginated"] = paginated;
    return _data;
  }
}

class MasterData {
  String? emailId;
  String? roName;
  String? gender;
  String? groupName;
  String? extNo;
  String? photopath;
  String? employeeId;
  String? empName;
  String? mobileNo;
  String? bloodGroup;
  String? empDesignation;

  MasterData({this.emailId, this.roName, this.gender, this.groupName, this.extNo, this.photopath, this.employeeId, this.empName, this.mobileNo, this.bloodGroup, this.empDesignation});

  MasterData.fromJson(Map<String, dynamic> json) {
    if(json["email_id"] is String) {
      emailId = json["email_id"];
    }
    if(json["ro_name"] is String) {
      roName = json["ro_name"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["group_name"] is String) {
      groupName = json["group_name"];
    }
    if(json["ext_no"] is String) {
      extNo = json["ext_no"];
    }
    if(json["photopath"] is String) {
      photopath = json["photopath"];
    }
    if(json["employee_Id"] is String) {
      employeeId = json["employee_Id"];
    }
    if(json["emp_name"] is String) {
      empName = json["emp_name"];
    }
    if(json["mobile_no"] is String) {
      mobileNo = json["mobile_no"];
    }
    if(json["blood_group"] is String) {
      bloodGroup = json["blood_group"];
    }
    if(json["emp_designation"] is String) {
      empDesignation = json["emp_designation"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["email_id"] = emailId;
    _data["ro_name"] = roName;
    _data["gender"] = gender;
    _data["group_name"] = groupName;
    _data["ext_no"] = extNo;
    _data["photopath"] = photopath;
    _data["employee_Id"] = employeeId;
    _data["emp_name"] = empName;
    _data["mobile_no"] = mobileNo;
    _data["blood_group"] = bloodGroup;
    _data["emp_designation"] = empDesignation;
    return _data;
  }
  Map<String, dynamic> toMap() {
    return {
      'email_id': emailId,
      'ro_name': roName,
      'gender':gender,
      'group_name':groupName,
      'ext_no':extNo,
      'photopath':photopath,
      'employee_Id':employeeId,
      'emp_name':empName,
      'mobile_no':mobileNo,
      'blood_group':bloodGroup,
      'emp_designation':empDesignation,
    };
  }
}