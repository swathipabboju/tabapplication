import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabapplication/constants/imageconstant.dart';
import 'package:tabapplication/routes/app_routes.dart';
import 'package:tabapplication/viewmodel/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImageConstants.splash_img),
                fit: BoxFit.cover),
          ),
        )
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final splashViewModel =
          Provider.of<SplashViewModel>(context, listen: false);
      await splashViewModel.getVersionCheckDetails(context);
    });
    /* Future.delayed(Duration(seconds: 2), () async {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
    }); */
  }
}
