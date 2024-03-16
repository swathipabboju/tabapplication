import 'package:flutter/material.dart';
import 'package:tabapplication/constants/colors.dart';

class ReusableCardComponent extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? height;
  final double? width;
  final void Function() ontap;

  const ReusableCardComponent({
    this.text,
    this.color,
    this.height,
    required this.ontap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.all(10),
        height: height ?? MediaQuery.of(context).size.height * 0.1,
        width: width ?? double.infinity,
        color: color ?? AppColors.primary,
        child: Center(
          child: Text(
            text ?? "",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
