import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/data/database.dart';
import 'package:tabapplication/model/mjpt/masterdata_response.dart';
import 'package:tabapplication/repository/downloadmasters_repo.dart';
import 'package:tabapplication/res/components/alertComponent.dart';
import 'package:tabapplication/res/constants/api_constants.dart';
import 'package:tabapplication/utils/locationutils.dart';

class MasterDataViewModel extends ChangeNotifier {
  final MasterDataRepository _masterDataRepository = MasterDataRepository();
  List<MasterData> masterDataList = [];
  bool isLoaderVisible = false;
  final double targetLatitude = 37.7749; // Target latitude
  final double targetLongitude = -122.4194; // Target longitude
  final double targetRadius = 5.0; // Target radius in kilometers

  bool isWithinRadius = false;
  // List<MasterData> get masterDataList => _masterDataList;
  changeLoaderStatus(bool status) {
    isLoaderVisible = status;
    notifyListeners();
  }

  getMasterDataDetails(BuildContext context) async {
    changeLoaderStatus(true);
    final response = await _masterDataRepository.masterDataDetails(
        context, ApiConstants.masters);
    if (response?.statusCode == 200) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      if (await dbHelper.isTableExists(DatabaseHelper.masterDataTable)) {
        await dbHelper.delete(DatabaseHelper.masterDataTable);
      }

      for (int i = 0; i < (response?.data?.length)!.toInt(); i++) {
        await dbHelper.insertOfficeCoordinates(MasterData(
          emailId: response?.data?[i].emailId,
          roName: response?.data?[i].roName,
          gender: response?.data?[i].gender,
          groupName: response?.data?[i].groupName,
          extNo: response?.data?[i].extNo,
          photopath: response?.data?[i].photopath,
          employeeId: response?.data?[i].employeeId,
          empName: response?.data?[i].empName,
          mobileNo: response?.data?[i].mobileNo,
          bloodGroup: response?.data?[i].bloodGroup,
          empDesignation: response?.data?[i].empDesignation,
        ));
      }
      changeLoaderStatus(false);
      Alerts.showAlertDialog(context, "Data Downloaded Successfully",
          Title: "MJPT", onpressed: () {
        Navigator.pop(context);
      }, buttontext: 'Ok', buttoncolor: AppColors.green);

      notifyListeners();
    }
  }

  Future<void> checkLocation() async {
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        "position ${position.latitude} ${position.longitude} ${targetLatitude} ${targetLongitude}");

   /*  double distanceInKm = await _calculateDistance(
        position.latitude, position.longitude, targetLatitude, targetLongitude); */
   await isLocationWithinAllowableRadius(position.longitude, position.longitude);

    // Check if current location is outside the target radius
    /*  if (distanceInKm > targetRadius) {
      setState(() {
        isWithinRadius = false;
      });
    } else {
      setState(() {
        isWithinRadius = true;
      });
    } */
  }

  Future<double> _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distanceInMeters = await Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters / 1000; // Convert meters to kilometers
  }
}
