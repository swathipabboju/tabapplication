import 'package:flutter/cupertino.dart';
import 'package:tabapplication/attendence.dart';
import 'package:tabapplication/routes/app_routes.dart';
import 'package:tabapplication/views/attendance_mjpt.dart';
import 'package:tabapplication/views/dashboard_screen.dart';
import 'package:tabapplication/views/splashscreen.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
       AppRoutes.splash: ((context) => SplashScreen()),
        AppRoutes.dashboardScreen: ((context) => DashboardScreen()),
         AppRoutes.attendance: ((context) => AttendanceMJPTScreen()),
     
      // AppRoutes.LogIn: ((context) => LogIn()),
      // AppRoutes.LogIn: ((context) => LogIn()),
      // AppRoutes.LogIn: ((context) => LogIn()),
    };
  }
}
