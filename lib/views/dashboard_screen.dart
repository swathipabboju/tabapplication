import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/constants/imageconstant.dart';
import 'package:tabapplication/res/components/loader.dart';
import 'package:tabapplication/res/components/reusableCardComponent.dart';
import 'package:tabapplication/res/constants/appStrings.dart';
import 'package:tabapplication/routes/app_routes.dart';
import 'package:tabapplication/viewmodel/masterdata_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String base64Image = "", random = "";
  Uint8List? bytes;
  bool profile = false;
  String? savedProfilePath = "";

  File? savedImage;
  MethodChannel platform = const MethodChannel('example.com/channel');
  MethodChannel platformChannelIOS =
      const MethodChannel("FlutterFramework/swift_native");
  Future<void> cameraScreen() async {
    try {
      random = await platform.invokeMethod('callRegistration');
    } on PlatformException catch (e1) {
      random = "";
      debugPrint("resultINvalue1111 $e1");
    }
  }

  Future<void> _faceRecogPunchIn() async {
    String random;
    try {
      random = await platform.invokeMethod('faceRecogPunchIn');
    } on PlatformException catch (e1) {
      random = "";
      print("resultvalue1111 $e1");
    }
    setState(() {
      //  resultvalue = random;
      // print("resultvalue1111 $resultvalue");
    });
  }

  Future<void> ProfileRegistartIOS() async {
    try {
      await platformChannelIOS.invokeMethod('getRegistartionIOS');
      //  print("Method invoked successfully");
    } on PlatformException catch (e) {
      print("Error invoking method: ${e.message}");
    }
  }

  Future<void> _handlProfileRegstrationResultiOS(
      dynamic result, BuildContext context) async {
    // print("Received result from iOS: $result");
// Assuming result is a Map
    if (result is Map) {
      String status = result['status'];
      String profileBase64 = result['result'];
      // print('Status: $status');
      // print('fr : $profileBase64');
      String attendancestatus = status;
      String profileBase64String = profileBase64;
      if (attendancestatus == "captured profile image") {
        //  registrationProvider.setIsLoadingStatus(true);
        bytes = base64.decode(profileBase64String);

        Uint8List compressedBytes =
            await compressBase64Image(profileBase64String);
        print('Compressed bytes: $compressedBytes');
        print("image in bytes$bytes");
        if (bytes != null) {
          // Create a temporary file
          // Get the application documents directory
          savedProfilePath =
              await saveImageToDocumentsDirectoryIOS(compressedBytes);
          if (savedProfilePath != null) {
            print('Image saved to: $savedProfilePath');
            // Use the saveImagePath as needed
          } else {
            print('Failed to save image.');
          }
        }
        profile = true;
        setState(() {});
        // print("profileBase64String$profileBase64String");
        // print("bytesIOS$bytes");
      } else {
        Navigator.pushNamed(context, AppRoutes.dashboardScreen);
      }
    }
  }

  Future<String?> saveImageToDocumentsDirectoryIOS(Uint8List bytes) async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      String subDir = '$dir/images';
      String fullPath = '$subDir/profile.jpg';

      // Ensure the subdirectory exists
      Directory(subDir).createSync(recursive: true);

      //String fullPath = '$dir/images/profileregister.jpg';
      print("local file full path ${fullPath}");
      File file = File(fullPath);
      await file.writeAsBytes(bytes);
      print(file.path);
      //savedProfilePath = file.path;
      // final result = await ImageGallerySaver.saveImage(bytes);
      // print(result);

      return file.path;
    } catch (e) {
      print('Error saving image: $e');
    }
    return null;
  }

  Future<Uint8List> compressBase64Image(String base64String) async {
    Uint8List bytes = base64.decode(base64String);
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      // Optional: set the minimum width of the output image
      quality: 0, // Optional: set the quality of the output image (0 - 100)
    );
    return Uint8List.fromList(compressedBytes);
  }

  Future<void> handleResultFromAndroidIn(
    dynamic result,
    BuildContext context,
  ) async {
    debugPrint("resultOUT111111 $result");
    profile = true;
    //bytes = base64.decode(result);
    final Directory? appDir = await getExternalStorageDirectory();
    File imageFile = File('${appDir?.path}/profile.jpg');
    if (await imageFile.exists()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('profileflag', true);
      loadImage();
      // imageFile.delete();
    } else {
      print('Image not found');
    }

    setState(() {
      // print("objectAndroid$bytes");
      // final RegExp regex = RegExp(r'^data:image\/\w+;base64,');
      // String base64Image = result.replaceFirst(regex, '');
      // bytes = base64Decode(base64Image);
    });

    // print("Received result from iOS IN: $result");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        // Get the application documents directory
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();

        // Create a File object for the saved image
        String imageName = 'profile.jpg'; // Replace with the actual image name
        File imageFile =
            File('${appDocumentsDirectory.path}/images/$imageName');

        // Check if the image file exists
        if (await imageFile.exists()) {
          profile = true;
          prefs.setBool("profileflag", true);
          setState(() {
            print(imageFile.path);

            //  savedImage = imageFile;
          });
        } else {
          profile = false;
          prefs.setBool("profileflag", false);

          print('Image not found');
        }
      } catch (e) {
        profile = false;
        prefs.setBool("profileflag", false);

        print('Error loading image: $e');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final masterdataprovider = Provider.of<MasterDataViewModel>(context);
    if (Platform.isAndroid) {
      platform.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onResultFromAndroidIN':
            handleResultFromAndroidIn(
              call.arguments,
              context,
            );
            debugPrint("call.arguments${call.arguments}");
            profile = true;
            setState(() {});
        }
      });
    } else if (Platform.isIOS) {
      platformChannelIOS.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onResultFromProfileRegistation':
            // print("punch in result");
            _handlProfileRegstrationResultiOS(call.arguments, context);
            break;
        }
      });
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Yes'),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              centerTitle: true,
              title: const Text(
                'DASHBOARD',
                style: TextStyle(color: AppColors.white, fontSize: 20),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await masterdataprovider.getMasterDataDetails(context);
                  },
                  icon: Image.asset(
                    ImageConstants.masterdb, // Replace with your image path
                    width: 24, // Adjust the width as needed
                    height: 24, // Adjust the height as needed
                    color: Colors.white, // Adjust the color as needed
                  ),
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableCardComponent(
                      ontap: () async {
                        Navigator.pushNamed(context, AppRoutes.attendance);
                      },
                      text: AppStrings.attendancetitle,
                    ),
                    const SizedBox(height: 16.0),
                    ReusableCardComponent(
                      text: AppStrings.update_profile,
                      ontap: () {
                        /* showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Update Profile'),
                              content: const Text(
                                  'Are you sure you want to delete this user?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('punchRecords');
                                    prefs.remove(SharedConstants.userName);
                                    prefs.setBool("profileflag", false);
                                    profile = false;
                                    setState(() {});
                                    Navigator.of(context).pop(true);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context1) {
                                          return CustomErrorAlert(
                                              Buttontext: "OK",
                                              descriptions: "User Profile Updated",
                                              Img: ImageConstants.correct,
                                              onPressed: () {
                                                Navigator.of(context1).pop(true);
                                                if (Platform.isAndroid) {
                                                  cameraScreen();
                                                } else if (Platform.isIOS) {
                                                  ProfileRegistartIOS();
                                                }
                                              },
                                              imagebg: Colors.white,
                                              bgColor: AppColors.primary);
                                        });
                                  },
                                ),
                              ],
                            );
                          },
                        ); */
                      },
                    ),
                    ReusableCardComponent(
                      ontap: () async {
                        await masterdataprovider.checkLocation();
                      },
                      text: "Co-ordinates",
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (masterdataprovider.isLoaderVisible) LoaderComponent()
        ],
      ),
    );
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Get the application documents directory
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();

      // Create a File object for the saved image
      String imageName = 'profile.jpg'; // Replace with the actual image name
      File imageFile = File('${appDocumentsDirectory.path}/images/$imageName');

      // Check if the image file exists
      if (await imageFile.exists()) {
        prefs.setBool("profileflag", true);
        setState(() {
          print(imageFile.path);

          //  savedImage = imageFile;
        });
      } else {
        prefs.setBool("profileflag", false);

        print('Image not found');
      }
    } catch (e) {
      prefs.setBool("profileflag", false);

      print('Error loading image: $e');
    }
  }
}
