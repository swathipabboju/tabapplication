import 'package:flutter/cupertino.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/constants/imageconstant.dart';
import 'package:tabapplication/model/mjpt/version_check_response.dart';
import 'package:tabapplication/repository/version_check_repo.dart';
import 'package:tabapplication/res/components/alertComponent.dart';
import 'package:tabapplication/res/constants/api_constants.dart';
import 'dart:io';
import 'package:tabapplication/res/constants/app_constants.dart';
import 'package:tabapplication/routes/app_routes.dart';
import 'package:tabapplication/utils/getAppversion.dart';
import 'package:tabapplication/utils/internetcheck.dart';

class SplashViewModel extends ChangeNotifier {
  bool isLoaderVisible = false;
  getVersionCheckDetails(BuildContext context) async {
    if (await internetCheck()) {
      changeLoaderStatus(true);
      try {
        VersioCheckRepository splashrepo = VersioCheckRepository();
        VersionCheckResponse? response = await splashrepo.versionCheckDetails(
            context, ApiConstants.versioncheck);
        if (response != null) {
          changeLoaderStatus(false);
          if (response.statusCode == AppConstants.STATUS_CODE_INT_200) {
            debugPrint("versionNumbejsdfskhfskjhskfjsf ${response.data?.versionNo}");
            Future.delayed(Duration(seconds: 1)).then((value) async {
              final versionNumber = await getAppVersion();
              
              double localVersion = double.tryParse(versionNumber) ?? 0.0;
              double? serverVersion =
                  double.tryParse(response.data?.versionNo ?? "0.0");
              debugPrint("versionNumber type ${versionNumber.runtimeType}");
              debugPrint("server version type::: ${serverVersion.runtimeType}");
              if (response.data != null &&
                      (localVersion > (serverVersion ?? 0.0)) ||
                  (localVersion == serverVersion)) {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.dashboardScreen);
              } else {
                if (Platform.isAndroid) {
                  Alerts.showAlertDialog(context,
                      "Your Current App Version is ${versionNumber}\n New Version Available , Please Update.",
                      Title: "MJPT",
                      imagePath: ImageConstants.appIcon, onpressed: () {
                    final packageId = "";
                    /*  final url = Uri.parse("$packageId");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    ); */
                  }, buttontext: "ok", buttoncolor: AppColors.appbarcolor);
                } else if (Platform.isIOS) {
                  Alerts.showAlertDialog(context,
                      "Your Current App Version is ${versionNumber}\n New Version Available , Please Update.",
                      Title: "Mjpt",
                      imagePath: ImageConstants.appIcon, onpressed: () {
                    final appId = "";
                    /*  final url = Uri.parse(
                        "https://apps.apple.com/us/app/NehruZoologicalPark/id$appId");
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    ); */
                  }, buttontext: "ok", buttoncolor: AppColors.buttoncolor);
                }
              }
            });
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
  }

  changeLoaderStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  
}
