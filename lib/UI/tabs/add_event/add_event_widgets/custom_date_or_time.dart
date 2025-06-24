import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomDateOrTime extends StatelessWidget {
  CustomDateOrTime({
    super.key,
    required this.imageDateOrTime,
    required this.chooseDateOrTime,
    required this.chooseDateOrTimeClicked,
    required this.textDateOrTime,
  });
  String imageDateOrTime;
  String textDateOrTime;
  String chooseDateOrTime;
  Function? chooseDateOrTimeClicked;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Image.asset(imageDateOrTime),
        SizedBox(
          width: width * 0.04,
        ),
        Text(
          textDateOrTime,
          style: Theme.of(context).brightness==Brightness.dark?AppStyle.white16bold:AppStyle.black16Bold,
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              chooseDateOrTimeClicked!();
            },
            child: Text(
              chooseDateOrTime,
              style: AppStyle.blue16bold,
            ))
      ],
    );
  }
}
