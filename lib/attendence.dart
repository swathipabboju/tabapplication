import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/constants/imageconstant.dart';
import 'package:tabapplication/model/punchRecordResponse.dart';
import 'package:tabapplication/res/components/alertComponent.dart';
import 'package:tabapplication/res/components/loader.dart';
import 'package:tabapplication/routes/app_routes.dart';
import 'package:tabapplication/sharedpreferences/share_pref_constants.dart';
import 'package:tabapplication/viewmodel/attendence_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  File? localImage;
  bool _isSearchVisible = false;
  MethodChannel platform = const MethodChannel('example.com/channel');
  MethodChannel platformChannelIOS =
      const MethodChannel("FlutterFramework/swift_native");
  List<PunchRecord> punchRecords = [];
  bool facedetectedIN = false;
  bool facedetectedOUT = false;
  String base64IMG = "";
  Uint8List? bytes;
  String resultvalue = "";
  Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> faceRecogPunchOutIOS() async {
    try {
      await platformChannelIOS.invokeMethod('getPunchOutIOS');
      // print("Method invoked successfully");
    } on PlatformException catch (e) {
      print("Error invoking method: ${e.message}");
    }
  }

  Future<void> faceRecogPunchInIOS() async {
    try {
      await platformChannelIOS.invokeMethod('getPunchInIOS');
      //  print("Method invoked successfully");
    } on PlatformException catch (e) {
      print("Error invoking method: ${e.message}");
    }
  }

  Future<void> _faceRecogPunchOut() async {
    String random;
    try {
      random = await platform.invokeMethod('faceRecogPunchOut');
    } on PlatformException catch (e) {
      random = "";
      print("resultvalue1111e $e");
    }
    setState(() {});
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

  Future<void> _handlePunchResultFromiOS(dynamic result, BuildContext context,
      AttendanceViewModel provider) async {
    //await _getCurrentLocation();
    String punchResult = '';
    print("Received result from iOS: $result");
// Assuming result is a Map
    if (result is Map) {
      // Access the "status" key and save it in a variable
      String status = result['status'];
      String fr = result['result'];

      // Now you can use the 'status' variable as needed in your Flutter class
      print('Status: $status');

      // Save the status to a class variable if needed
      String attendancestatus = status;
      String frResult = fr;

      print("punch result in Ios: $attendancestatus");
      if (attendancestatus == "punchIn" && frResult == "face Matched") {
        provider.changeLoaderStatus(false);
        setState(() {
          resultvalue = attendancestatus;
        });
        punchRecords.add(PunchRecord(
            'Punch In', DateFormat("hh:mm:ss a").format(DateTime.now()), "IN"));
        _savePunchRecords();
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Attendance'),
                content: Text('Punch in Successful'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context,
                          AppRoutes.dashboardScreen); // Close the alert
                    },
                  ),
                ],
              );
            });
      } else if (attendancestatus == "punchOut" && frResult == "face Matched") {
        provider.changeLoaderStatus(false);
        setState(() {
          resultvalue = attendancestatus;
        });
        punchRecords.add(PunchRecord('Punch Out',
            DateFormat("hh:mm:ss a").format(DateTime.now()), "OUT"));
        punchResult = "Punch out Successful";
        _savePunchRecords();

        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Attendance'),
                content: Text('Punch out Successful'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context,
                          AppRoutes.dashboardScreen); // Close the alert
                    },
                  ),
                ],
              );
            });
      } else {
        provider.changeLoaderStatus(false);
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
      }
    } else {
      provider.changeLoaderStatus(false);
      punchResult = '';
    }
  }

  Future<void> handleResultFromAndroidIn(dynamic result, BuildContext context,
      AttendanceViewModel provider) async {
    debugPrint("resultOUT111111 $result");
    print("Received result from iOS IN: $result");

    if (result == "trueIN") {
      facedetectedIN = true;
      facedetectedOUT = false;
      punchRecords.add(PunchRecord(
          'Punch In', DateFormat("hh:mm:ss a").format(DateTime.now()), "IN"));
      provider.changeLoaderStatus(false);
      Alerts.showAlertDialog(
        context,
        "Punch In Successful",
        Title: "Punch In",
        imagePath: ImageConstants.correct,
        onpressed: () {
          Navigator.pop(context);
        },
        buttoncolor: Colors.green,
        buttontext: "OK",
      );

      //  _punchInTAP(context);
    } else if (result == "trueOUT") {
      facedetectedOUT = true;
      facedetectedIN = false;
      punchRecords.add(PunchRecord(
          'Punch Out', DateFormat("hh:mm:ss a").format(DateTime.now()), "OUT"));
      provider.changeLoaderStatus(false);
      Alerts.showAlertDialog(
        context,
        "Punch Out Successful",
        Title: "Punch Out",
        imagePath: ImageConstants.correct,
        onpressed: () {
          Navigator.pop(context);
        },
        buttoncolor: Colors.green,
        buttontext: "OK",
      );
      print("Received result from iOS OUT: $result");
    } else if (result == "Face not matched") {
      provider.changeLoaderStatus(false);
    } else {
      provider.changeLoaderStatus(false);
    }
    await _savePunchRecords();
    provider.changeLoaderStatus(false);
    setState(() {});
  }

  Future<void> _savePunchRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> punchRecordsJsonList =
        punchRecords.map((record) => jsonEncode(record.toJson())).toList();
    prefs.setStringList('punchRecords', punchRecordsJsonList);
    prefs.setString('lastPunchDate', _getCurrentDate());
  }

  Future<void> _getPunchRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? punchRecordsJsonList =
        prefs.getStringList(SharedConstants.punchRecords);
    if (punchRecordsJsonList != null) {
      punchRecords = punchRecordsJsonList
          .map((jsonString) => PunchRecord.fromJson(jsonDecode(jsonString)))
          .toList();
      setState(() {});
      print("punch records length in init ${punchRecords.length}");
    }
  }

  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Function to check if the day has changed
  Future<void> _checkDayChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastPunchDate = prefs.getString('lastPunchDate');
    String currentPunchDate = _getCurrentDate();
    if (lastPunchDate != null && lastPunchDate != currentPunchDate) {
      // Day has changed, clear punch records
      punchRecords.clear();
      prefs.setString('lastPunchDate', currentPunchDate);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      localImage = await getImageFile();
      base64IMG = await fileToBase64(localImage ?? File(''));
      bytes = base64Decode(base64IMG);
      setState(() {
        print("localImage --------- $localImage");
      });
      await _getPunchRecords();
      await _checkDayChange();
    });
  }

  Future<File?> getImageFile() async {
    try {
      if (Platform.isIOS) {
        return await getImagePathForIOS();
      } else if (Platform.isAndroid) {
        return await getImagePathForAndroid();
      }
      return null;
    } catch (e) {
      print('Error retrieving image: $e');
      return null;
    }
  }

  Future<File?> getImagePathForAndroid() async {
    try {
      // Get the external storage directory for Android
      Directory? appDir = await getExternalStorageDirectory();
      if (appDir != null) {
        String imagesPath = '${appDir.path}/profile.jpg';
        print("imagesPath is $imagesPath");
        File imageFile = File(imagesPath);
        if (await imageFile.exists()) {
          print("imageFile is $imageFile");
          return imageFile; // Return the image file if it exists
        }
      }
      return null;
    } catch (e) {
      print('Error retrieving image for Android: $e');
      return null;
    }
  }

  Future<File?> getImagePathForIOS() async {
    try {
      // Get the application documents directory for iOS
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      print("ios path is ${appDocumentsDirectory.path}");
      String imagesPath = '${appDocumentsDirectory.path}/images/profile.jpg';

      File imageFile = File(imagesPath);
      if (await imageFile.exists()) {
        return imageFile; // Return the image file if it exists
      }
      return null;
    } catch (e) {
      print('Error retrieving image for iOS: $e');
      return null;
    }
  }

  // print("Received result from iOS IN: $result");

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceViewModel>(context);

    if (Platform.isAndroid) {
      platform.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onResultFromAndroidIN':
            handleResultFromAndroidIn(call.arguments, context, provider);
            print("call.arguments${call.arguments}");

            break;
        }
      });
    } else if (Platform.isIOS) {
      platformChannelIOS.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onResultFromPunchIniOS':
            _handlePunchResultFromiOS(call.arguments, context, provider);
            break;
          case 'onResultFromPunchOutiOS':
            _handlePunchResultFromiOS(call.arguments, context, provider);
            break;
        }
      });
    }
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text("Attendance"),
            ),
            body: Container(
                color: AppColors.primaryDark,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    (bytes != null)
                        ? Expanded(
                            child: Image.memory(
                                width: 100, height: 100, bytes ?? Uint8List(0)))
                        : Expanded(
                            flex: 1,
                            child: Image.asset(
                              ImageConstants.appIcon,
                              width: 100,
                              height: 100,
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: GridView.builder(
                        itemCount: punchRecords.length,
                        itemBuilder: (context, index) {
                          String timestamp =
                              punchRecords[index].timestamp.toString();
                          DateTime dateTime =
                              DateFormat("hh:mm:ss a").parse(timestamp);
                          String formattedTime =
                              DateFormat('hh:mm a').format(dateTime);
                          print("time:::$formattedTime");
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, right: 6, left: 12, bottom: 0.0),
                              child: Column(
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: punchRecords[index]
                                                                .type ==
                                                            "Punch In"
                                                        ? AppColors.green
                                                        : AppColors.maroon,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      color: punchRecords[index]
                                                                  .type ==
                                                              "Punch In"
                                                          ? AppColors.green
                                                          : AppColors.maroon,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${formattedTime}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: punchRecords[index]
                                                                  .type ==
                                                              "Punch In"
                                                          ? AppColors.green
                                                          : AppColors.maroon,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Image.asset(
                                                      punchRecords[index]
                                                                  .type ==
                                                              "Punch In"
                                                          ? ImageConstants
                                                              .location
                                                          : ImageConstants
                                                              .location,
                                                      width: 25.0,
                                                      height: 25.0,
                                                      // color:  punchRecords[index]
                                                      //             .type ==
                                                      //         "Punch In" ?AppColors.green:AppColors.maroon
                                                    ),
                                                  ),
                                                  Text(
                                                    "${punchRecords[index].location}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 4),
                        ),
                      ),
                    ),
                  ],
                )),
            bottomSheet: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.09,
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.09,
                    color: ((punchRecords.length) % 2 == 0)
                        ? AppColors.green
                        : AppColors.grey,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          ((punchRecords.length) % 2 == 0)
                              ? AppColors.green
                              : AppColors.grey,
                        ),
                      ),
                      onPressed: (((punchRecords.length) % 2 == 0))
                          ? () {
                              if (Platform.isAndroid) {
                                provider.changeLoaderStatus(true);
                                _faceRecogPunchIn();
                              } else if (Platform.isIOS) {
                                provider.changeLoaderStatus(true);
                                faceRecogPunchInIOS();
                              }
                            }
                          : () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "PUNCH IN",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: ((punchRecords.length) % 2 != 0)
                        ? AppColors.maroon
                        : AppColors.grey,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          ((punchRecords.length) % 2 != 0)
                              ? AppColors.maroon
                              : AppColors.grey,
                        ),
                      ),
                      onPressed: (((punchRecords.length) % 2 != 0))
                          ? () {
                              if (Platform.isAndroid) {
                                provider.changeLoaderStatus(true);
                                _faceRecogPunchOut();
                              } else if (Platform.isIOS) {
                                provider.changeLoaderStatus(true);
                                faceRecogPunchOutIOS();
                              }
                            }
                          : () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "PUNCH OUT",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        if (provider.isLoaderVisible) LoaderComponent(),
      ],
    );
  }
}
