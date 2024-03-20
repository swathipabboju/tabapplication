/* import 'dart:async';
import 'package:Virtuo/models/side_menu/download_masters/get_work_area_data_response.dart';
import 'package:Virtuo/res/ReusableWidgets/attendance_widgets/mark_attendance_in_office_out_time.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:Virtuo/models/dashboard/attendance/get_attendance_response.dart';
import 'package:Virtuo/models/dashboard/attendance/mark_attendance_response.dart';
import 'package:Virtuo/models/side_menu/download_masters/get_office_coordinates_response.dart';
import 'package:Virtuo/repository/dashboard/attendance/get_attendance_repository.dart';
import 'package:Virtuo/res/AppColors/colors.dart';
import 'package:Virtuo/res/CustomAlerts/WarningAlert.dart';
import 'package:Virtuo/res/CustomAlerts/customAlert_1.dart';
import 'package:Virtuo/res/ReusableWidgets/show_toast.dart';
import '../../../models/login/loginDetails.dart';
import '../../../res/Constants/image_constants.dart';
import '../../../res/ReusableWidgets/attendance_widgets/mark_attendance_out_office_out_time.dart';
import '../../../res/Routes/appRoutes.dart';
import '../../../res/Strings/strings.dart';
import '../../../utils/getAddress.dart';
import '../../../utils/location.dart';

class AttendanceInfoViewModel with ChangeNotifier {
  Timer? timerStart;
  NavigationToDashboard(BuildContext context) {
    timerSet = "";
    timerStart?.cancel();
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get getIsLoadingStatus => _isLoading;
  setIsLoadingStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  GetAttendanceInfoRepository _getAttendanceInfoRepository =
      GetAttendanceInfoRepository();
  GetAttendanceResponseModel? AttendanceInfoResponse =
      GetAttendanceResponseModel();
  GetAttendanceResponseModel? get GetAttendanceInfoReport =>
      AttendanceInfoResponse;
  String ResponseStatusMsg = "";
  String get GetResStatusMsg => ResponseStatusMsg;

  GetAttServiceCall(LoginResponseDetailsModel loginDetails,
      BuildContext context, MaterialColor themeColor) async {
    final EndPoint = loginDetails.employeeId.toString() +
        '/' +
        loginDetails.empId.toString();
    final Response =
        await _getAttendanceInfoRepository.GetAttendanceInfoApiCall(
            context, EndPoint);
    if (Response.statusCode == 200) {
      AttendanceInfoResponse = Response;
    } else if (Response.statusCode == 201) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
              Buttontext: AppStrings.ok,
              descriptions: "${Response.statusMessage ?? ""}",
              Img: ImageConstants.CrossIcon,
              onPressed: () {
                timerSet = "";
                timerStart?.cancel();
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              },
              imagebg: AppColors.white,
              bgColor: AppColors.red,
            );
          });
    } //202---Today is a Holiday Case
    else if (Response.statusCode == 202) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WarningAlert(
              Buttontext1: AppStrings.cancel,
              Buttontext2: AppStrings.ok,
              descriptions:
                  "${Response.statusMessage ?? ""} \n \nWould you like to submit the attendance?",
              img: ImageConstants.WarningIcon,
              onButton1Pressed: () {
                NavigationToDashboard(context);
              },
              onButton2Pressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.worklog,
                    arguments: loginDetails);
              },
            );
          });
    } //203---You have Appled fleave for today
    else if (Response.statusCode == 203) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WarningAlert(
              Buttontext1: AppStrings.cancel,
              Buttontext2: AppStrings.ok,
              descriptions:
                  "${Response.statusMessage ?? ""} \n \nWould you like to submit the attendance?",
              img: ImageConstants.WarningIcon,
              onButton1Pressed: () {
                NavigationToDashboard(context);
              },
              onButton2Pressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.worklog,
                    arguments: loginDetails);
              },
            );
          });
    } // Work Log not submitted current/previous day
    else if (Response.statusCode == 204) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WarningAlert(
              Buttontext1: AppStrings.cancel,
              Buttontext2: AppStrings.ok,
              descriptions:
                  "${Response.statusMessage ?? ""} \n \n Would you like to submit the worklog",
              img: ImageConstants.WarningIcon,
              onButton1Pressed: () {
                NavigationToDashboard(context);
              },
              onButton2Pressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.worklog,
                    arguments: loginDetails);
              },
            );
          });
    } //previous day outtime not submited So user navigated to punchinvc class
    else if (Response.statusCode == 205) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      String dateTimeString = Response.data?.lastWorkingDay ?? "1999-11-27";
      // String dateTimeString = '2023-04-26'; // Uncomment this line to test with date only

      // Check if the string contains a time component
      bool hasTime = RegExp(r'\d{2}:\d{2}:\d{2}').hasMatch(dateTimeString);

      // Parse the string into a DateTime object
      DateTime date = hasTime
          ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString)
          : DateFormat('yyyy-MM-dd').parse(dateTimeString);

      // Format the DateTime object into the desired format
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WarningAlert(
              Buttontext1: AppStrings.No,
              Buttontext2: AppStrings.Yes,
              descriptions:
                  "${Response.statusMessage ?? ""} \n \n Would you like to submit the attendance",
              img: ImageConstants.WarningIcon,
              onButton1Pressed: () {
                NavigationToDashboard(context);
              },
              onButton2Pressed: () async {
                final LocationEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (LocationEnabled) {
                  // Get current location
                  Position currentLocation =
                      await Geolocator.getCurrentPosition();
                  /* final latitude = 17.4448291;
                  final longitude = 78.3623093;
                  final result = await isLocationWithinAllowableRadius(
                      context, latitude, longitude); */
                  final result = await isLocationWithinAllowableRadius(context,
                      currentLocation.latitude, currentLocation.longitude);

                  bool inOffice = result is OfficeCoordinatesData;
                  if (result is OfficeCoordinatesData) {
                    print(
                        "result Allowable Radius:::: ${result.allowableradius}");
                    Navigator.pop(context);
                    showModalBottomSheet(
                      enableDrag: false,
                      isScrollControlled: true,
                      isDismissible: false,
                      context: context,
                      builder: (context) {
                        return ShowInOfficeOutTimeSubmissionSheet(
                            loginDetails: loginDetails,
                            themeColor: themeColor,
                            attendanceInfo: AttendanceInfoResponse,
                            punchoutDate: formattedDate,
                            inOffice: inOffice,
                            currentLocation: currentLocation,
                            InOfficeCoordinatesResult: result,
                            shouldRemarkTxtHidden: true);
                      },
                    );
                  } else {
                    final currentAddress = await GetCurrentAddress()
                        .getCurrentAddress(currentLocation.latitude,
                            currentLocation.longitude);
                    // current location is not within allowable radius of permitted locations
                    showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: showOutOfficeSheetComponent(
                              Address: currentAddress[0],
                              latitidue: currentLocation.latitude,
                              longitude: currentLocation.longitude,
                              loginDetails: loginDetails,
                              finalDayOutType: false,
                              themeColor: themeColor,
                              attendanceInfo: AttendanceInfoResponse,
                              punchoutDate: formattedDate,
                              state: currentAddress[1],
                              city: currentAddress[2],
                              shouldRemarkTxtHidden: true),
                        );
                      },
                    );
                    ShowToasts.showToast(
                        'Location is not within meters of a permitted location.');
                  }
                } else {
                  NavigationToDashboard(context);
                }
              },
            );
          });
    } // print("exceeded the 5 time limit of the month")
    else if (Response.statusCode == 208) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      String dateTimeString = Response.data?.lastWorkingDay ?? "1999-11-27";
      // String dateTimeString = '2023-04-26'; // Uncomment this line to test with date only

      // Check if the string contains a time component
      bool hasTime = RegExp(r'\d{2}:\d{2}:\d{2}').hasMatch(dateTimeString);

      // Parse the string into a DateTime object
      DateTime date = hasTime
          ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString)
          : DateFormat('yyyy-MM-dd').parse(dateTimeString);

      // Format the DateTime object into the desired format
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WarningAlert(
              Buttontext1: AppStrings.No,
              Buttontext2: AppStrings.Yes,
              descriptions:
                  "${Response.statusMessage ?? ""} \n \n Would you like to submit the attendance",
              img: ImageConstants.WarningIcon,
              onButton1Pressed: () {
                NavigationToDashboard(context);
              },
              onButton2Pressed: () async {
                final LocationEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (LocationEnabled) {
                  // Get current location
                  Position currentLocation =
                      await Geolocator.getCurrentPosition();
                  /* final latitude = 17.4448291;
                  final longitude = 78.3623093;
                  final result = await isLocationWithinAllowableRadius(
                      context, latitude, longitude); */
                  final result = await isLocationWithinAllowableRadius(context,
                      currentLocation.latitude, currentLocation.longitude);

                  bool inOffice = result is OfficeCoordinatesData;
                  if (result is OfficeCoordinatesData) {
                    print(
                        "result Allowable Radius:::: ${result.allowableradius}");
                    Navigator.pop(context);
                    showModalBottomSheet(
                      enableDrag: false,
                      isScrollControlled: true,
                      isDismissible: false,
                      context: context,
                      builder: (context) {
                        return ShowInOfficeOutTimeSubmissionSheet(
                            loginDetails: loginDetails,
                            themeColor: themeColor,
                            attendanceInfo: AttendanceInfoResponse,
                            punchoutDate: formattedDate,
                            inOffice: inOffice,
                            currentLocation: currentLocation,
                            InOfficeCoordinatesResult: result,
                            shouldRemarkTxtHidden: false);
                      },
                    );
                  } else {
                    final currentAddress = await GetCurrentAddress()
                        .getCurrentAddress(currentLocation.latitude,
                            currentLocation.longitude);
                    // current location is not within allowable radius of permitted locations
                    showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: showOutOfficeSheetComponent(
                              Address: currentAddress[0],
                              latitidue: currentLocation.latitude,
                              longitude: currentLocation.longitude,
                              loginDetails: loginDetails,
                              finalDayOutType: false,
                              themeColor: themeColor,
                              attendanceInfo: AttendanceInfoResponse,
                              punchoutDate: formattedDate,
                              state: currentAddress[1],
                              city: currentAddress[2],
                              shouldRemarkTxtHidden: false),
                        );
                      },
                    );
                    ShowToasts.showToast(
                        'Location is not within meters of a permitted location.');
                  }
                } else {
                  NavigationToDashboard(context);
                }
              },
            );
          });
    } //Session Expired case
    else if (Response.statusCode == 401) {
      AttendanceInfoResponse = Response;
      ResponseStatusMsg = Response.statusMessage ?? "";
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
              descriptions: "Session Expired , Please login again!",
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              Img: ImageConstants.CrossIcon,
              bgColor: AppColors.red,
            );
          });
    } else {
      if (Response.statusCode != null)
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
              bgColor: AppColors.red,
              descriptions: "${Response.statusMessage}",
              Buttontext: AppStrings.ok,
              onPressed: () {
                Navigator.pop(context);
              },
              Img: ImageConstants.closeBgicon,
              imagebg: AppColors.white,
            );
          },
        );
    }
  }

  String timerSet = "";
  String get timerTitle => timerSet;
  String timerFormat = "";

  startTimer(BuildContext context, int start) {
    const oneSec = Duration(seconds: 1);
    timerStart = Timer.periodic(oneSec, (timer) {
      if (start != 0) {
        start--;
        final duration = Duration(seconds: start);
        timerSet =
            '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        notifyListeners();
      } else {
        start = 0;
        NavigationToDashboard(context);
      }
    });
  }

  MarkAttendanceResponse? MarkAttRes;
  MarkAttendanceServiceCall(
      String address,
      String attendanceTime,
      String attendanceType,
      LoginResponseDetailsModel loginDetails,
      String empRemarks,
      bool finalPunchout,
      String office_premises,
      String other_reason,
      String requestType,
      BuildContext context,
      String otherWorkLocation,
      String state,
      double? latitude,
      double? longitude,
      String? locality,
      int? workLocationId,
      int? workReasonId) async {
    final Response = await _getAttendanceInfoRepository.GetMarkAttendanceApi(
        context,
        address,
        attendanceTime,
        attendanceType,
        loginDetails,
        empRemarks,
        finalPunchout,
        latitude,
        longitude,
        locality,
        workLocationId,
        workReasonId,
        requestType,
        office_premises,
        other_reason,
        otherWorkLocation,
        state);
    setIsLoadingStatus(false);
    if (Response.statusCode == 200) {
      MarkAttRes = Response;
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
                Buttontext: "OK",
                descriptions: Response.statusMessage ?? "",
                Img: ImageConstants.CorrectIcon,
                onPressed: () {
                  NavigationToDashboard(context);
                },
                imagebg: Colors.white,
                bgColor: AppColors.green);
          });
    } else if (Response.statusCode == 201) {
      MarkAttRes = Response;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
                Buttontext: "OK",
                descriptions: Response.statusMessage ?? "",
                Img: ImageConstants.WarningIcon,
                onPressed: () {
                  NavigationToDashboard(context);
                },
                imagebg: Colors.white,
                bgColor: AppColors.red);
          });
    } else {
      if (Response.statusCode != null) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
              bgColor: AppColors.red,
              descriptions: "${Response.statusMessage}",
              Buttontext: AppStrings.ok,
              onPressed: () {
                Navigator.pop(context);
              },
              Img: ImageConstants.closeBgicon,
              imagebg: AppColors.white,
            );
          },
        );
      }
    }
    notifyListeners();
  }

  showLocationTurnedOffAlert(
      LoginResponseDetailsModel loginDetails, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningAlert(
            Buttontext2: AppStrings.ok,
            Buttontext1: AppStrings.cancel,
            descriptions:
                "Location Turned Off \n Please turn on the device location to proceed.",
            img: ImageConstants.WarningIcon,
            onButton2Pressed: () {
              timerSet = "";
              timerStart?.cancel();
              Navigator.pushReplacementNamed(context, AppRoutes.attendance,
                  arguments: loginDetails);
            },
            onButton1Pressed: () {
              timerSet = "";
              timerStart?.cancel();
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            },
          );
        });
  }

  showLocationPermissionAlert(
      LoginResponseDetailsModel loginDetails, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningAlert(
            Buttontext2: AppStrings.ok,
            Buttontext1: AppStrings.cancel,
            descriptions:
                "Location is not enabled \n Please allow permission to proceed further.",
            img: ImageConstants.WarningIcon,
            onButton2Pressed: () {
              timerSet = "";
              timerStart?.cancel();
              Navigator.pushReplacementNamed(context, AppRoutes.attendance,
                  arguments: loginDetails);
            },
            onButton1Pressed: () {
              timerSet = "";
              timerStart?.cancel();
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            },
          );
        });
  }

  List<WorkAreaData> workAreaDataFromDb = [];
  List<WorkAreaData> get getWorkAreaDataFromDb => workAreaDataFromDb;

  WorkAreaDataFromDb() async {
    final response = await _getAttendanceInfoRepository.getWorkAreaData();
    workAreaDataFromDb = response;
  }

  bool validate(int? selectedLocationId, int? selectedReasonId, String remarks,
      String others, BuildContext context, WorkReason? selectReasonData) {
    setIsLoadingStatus(false);
    if (selectedLocationId == 0) {
      ShowToasts.showToast("Please Select Work Location",
          bgcolor: AppColors.black);
      return false;
    } else if (selectedReasonId == 0) {
      ShowToasts.showToast("Please Select Work Reason",
          bgcolor: AppColors.black);
      return false;
    } else if (selectReasonData?.reason == "Other" && others.isEmpty) {
      ShowToasts.showToast("Please Enter Work Reason",
          bgcolor: AppColors.black);
      return false;
    } else if (remarks.isEmpty) {
      ShowToasts.showToast("Please Enter Remarks", bgcolor: AppColors.black);
      return false;
    }
    return true;
  }

  Future<void> updateEmployeeProfile(
      String empId, String base64_selfiePhoto, BuildContext context) async {
    final result = await _getAttendanceInfoRepository.updateProfile(
        context, empId, base64_selfiePhoto);
    setIsLoadingStatus(false);
    if (result.statusCode == 200) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
                Buttontext: "OK",
                descriptions: result.statusMessage ?? "",
                Img: ImageConstants.CorrectIcon,
                onPressed: () {
                  NavigationToDashboard(context);
                },
                imagebg: Colors.white,
                bgColor: AppColors.green);
          });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertWithSingleButton(
              bgColor: AppColors.red,
              descriptions: "${result.statusMessage}",
              Buttontext: AppStrings.ok,
              onPressed: () {
                Navigator.pop(context);
              },
              Img: ImageConstants.closeBgicon,
              imagebg: AppColors.white,
            );
          });
    }

    print("result $result");
  }

  bool validateFields(String base64_selfiePhoto) {
    if (base64_selfiePhoto.isEmpty) {
      ShowToasts.showToast("Please Upload Selfie", bgcolor: AppColors.black);
      return false;
    }
    return true;
  }
}
 */