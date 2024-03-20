import 'package:flutter/material.dart';

class AlertWithSingleButton extends StatefulWidget {
  final String title, descriptions, Buttontext;
  final String Img;
  final Color? imagebg;
  final Color? bgColor;
  final void Function()? onPressed;
 // final String version;

  const AlertWithSingleButton({
    Key? key,
    required this.title,
    required this.descriptions,
    required this.Buttontext,
    required this.onPressed,
    this.bgColor,
    required this.Img,
   // required this.version,
    required this.imagebg,

  }) : super(key: key);

  @override
  _AlertWithSingleButtonState createState() => _AlertWithSingleButtonState();
}

class _AlertWithSingleButtonState extends State<AlertWithSingleButton> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 10),
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /* Text(
               // widget.version,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ) */
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                        minimumSize: MaterialStateProperty.all(Size(220, 40)),
                        backgroundColor: MaterialStateProperty.all(
                            widget.bgColor ?? Colors.white)),
                    onPressed: widget.onPressed,
                    child: Text(
                      widget.Buttontext,
                      style: TextStyle(fontSize: 14),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CircleAvatar(
              backgroundColor: widget.imagebg ?? Colors.white,
              radius: 35,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  child: Image.asset(
                    widget.Img,
                  //  width: 100, height: 100,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
