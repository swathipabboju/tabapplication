import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tabapplication/constants/colors.dart';
import 'package:tabapplication/constants/imageconstant.dart';
import 'package:tabapplication/res/appAlerts/alert_single_button.dart';
import 'package:tabapplication/res/constants/appStrings.dart';

class ErrorHandlingUtils {
  
  bool _isLoading = false;

  bool get getIsLoadingStatus => _isLoading;

  void setIsLoadingStatus(bool status) {
    _isLoading = status;
  
  }

  static String handleError(dynamic e, BuildContext context) {
    String msg = "";
    if (e is DioError) {
      if (e.type == DioErrorType.response) {
        final responseBody = e.response?.data;
        if (responseBody != null) {
          final jsonData = json.encode(responseBody);
          msg = getErrorMessage(jsonData);
        }
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        msg = "Connection timed out";
      } else {
        msg = "Server not responding: ${e.message}";
      }
    } else if (e is SocketException) {
      msg = "Something went wrong: ${e.message}";
    } else {
      msg = "Something went wrong: ${e.toString()}";
    }
    return msg;
  }

  static String getErrorMessage(String jsonData) {
    try {
      final parsedJson = json.decode(jsonData);
      return parsedJson['error']['message'];
    } catch (e) {
      return "Something went wrong,Please try again later";
    }
  }

  showErrorDialog(
    BuildContext context,
    String errorMessage,
  ) {
   setIsLoadingStatus(false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertWithSingleButton(
          Buttontext: AppStrings.ok,
          Img: ImageConstants.error,
          descriptions: "$errorMessage",
          imagebg: null,
          onPressed: () {
            Navigator.pop(context);
          },
          title: 'MJPT ',
          bgColor: AppColors.buttoncolor,
        );
      },
    );
  }
}
