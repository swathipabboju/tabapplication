import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  return position;
}

Future<dynamic> isLocationWithinAllowableRadius(
    currentlatitude, currelongitude) async {
  // Check if location services are enabled
  bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationEnabled) {
    await Geolocator.requestPermission();
    Fluttertoast.showToast(msg: "Please Enable the location");
  }
  double distanceInMeters = await Geolocator.distanceBetween(
    currentlatitude,
    currelongitude,
    double.parse("37.7749"),
    double.parse("-122.4194"),
  );

  if (distanceInMeters <= double.parse("100" ?? "")) {
    print("within radius");
  }

  /*  final db = DatabaseHelper();
  final officeCoordinates = await db.getOfficeCoordinates();
  if (officeCoordinates.length == 0) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningAlert(
            descriptions:
                'Data not available for Office Cordinates,\n Would you like to download the data?',
            Buttontext1: 'No',
            Buttontext2: 'Yes',
            img: ImageConstants.error,
            onButton1Pressed: () {
              Navigator.pop(context);
            },
            onButton2Pressed: () {
          /*     Navigator.pushReplacementNamed(
                  context, AppRoutes.masterDataDetails); */
            });
      },
    );
  } else if (!(officeCoordinates.length == 0)) {
    // Loop through permitted locations and check distance
    for (var location in officeCoordinates) {
      double distanceInMeters = await Geolocator.distanceBetween(
        currentlatitude,
        currelongitude,
        double.parse(location.latitude ?? ""),
        double.parse(location.longitude ?? ""),
      );

      if (distanceInMeters <= double.parse(location.allowableradius ?? "")) {
        print("${location.allowableradius}");
        return location;
      }
    }
  } */

  // No permitted location within allowable radius
  return false;
}
