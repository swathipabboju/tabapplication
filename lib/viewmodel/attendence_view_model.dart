import 'package:flutter/cupertino.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/model/mjpt/get_attendence_info_response.dart';
import 'package:tabapplication/repository/attendance_repo.dart';
import 'package:tabapplication/res/components/alertComponent.dart';
import 'package:tabapplication/res/constants/api_constants.dart';
import 'package:tabapplication/res/constants/app_constants.dart';
import 'package:tabapplication/utils/internetcheck.dart';

class AttendanceViewModel extends ChangeNotifier {
  bool isLoaderVisible = false;
  AttendanceInfoData? attendanceInfoData;
  getAttendanceInfoDetails(BuildContext context, String id) async {
    if (await internetCheck()) {
      changeLoaderStatus(true);
      try {
        AttendanceRepository attendanceRepo = AttendanceRepository();
        GetAttendanceInfoResponse? response =
            await attendanceRepo.attendanceInfoDetails(
                context, ApiConstants.getAttendanceDetails + "/${id}/${id}");
        if (response != null) {
          changeLoaderStatus(false);
          if (response.statusCode == AppConstants.STATUS_CODE_INT_200) {
            attendanceInfoData = response.data;
          } else if (response.statusCode == AppConstants.STATUS_CODE_INT_400) {
            Alerts.showAlertDialog(
              context,
              response.statusMessage,
              titleColor: AppColors.buttoncolor,
              Title: "Mjpt",
              onpressed: () {
                Navigator.pop(context);
              },
              buttontext: "ok",
            );
          } else {
            Alerts.showAlertDialog(
              context,
              response.statusMessage,
              titleColor: AppColors.buttoncolor,
              Title: "Mjpt",
              onpressed: () {
                Navigator.pop(context);
              },
              buttontext: "ok",
            );
          }
        } else {
          Alerts.showAlertDialog(
            context,
            "server not responding",
            titleColor: AppColors.buttoncolor,
            Title: "Mjpt",
            onpressed: () {
              Navigator.pop(context);
            },
            buttontext: "ok",
          );
        }
      } catch (e) {
        changeLoaderStatus(false);
        Alerts.showAlertDialog(context, "server not responding",
            titleColor: AppColors.buttoncolor, Title: "Mjpt", onpressed: () {
          Navigator.pop(context);
        }, buttontext: "ok");
      }
    } else {
      Alerts.showAlertDialog(context, "please check your intenret connection",
          titleColor: AppColors.buttoncolor, Title: "Mjpt", onpressed: () {
        Navigator.pop(context);
      }, buttontext: "ok");
    }
    notifyListeners();
  }

  changeLoaderStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }
}
