import 'package:evently_app/utls/app_colo.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabEventWidget extends StatefulWidget {
  final bool isSelected;
  final String eventName;
  Color selectedEventDark;
  Color selectedEventLight;
  TextStyle  styleEventDarkSelected;
  TextStyle  styleEventDarkUnSelected;
  TextStyle  styleEventLightUnSelected;
  TextStyle  styleEventLightSelected;
   TabEventWidget(
      {super.key, 
      required this.isSelected,
       required this.eventName,
       required this.selectedEventDark,
       required this.selectedEventLight,
       required this.styleEventDarkSelected,
       required this.styleEventDarkUnSelected,
       required this.styleEventLightSelected,
       required this.styleEventLightUnSelected,
       });
 
  @override
  State<TabEventWidget> createState() => _TabEventWidgetState();
}

class _TabEventWidgetState extends State<TabEventWidget> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Color containerColor1 = Theme.of(context).brightness == Brightness.dark
        ? widget.selectedEventDark
        : widget.selectedEventLight;
    TextStyle selectedStyle=  Theme.of(context).brightness == Brightness.dark
        ? widget.styleEventDarkSelected:widget.styleEventLightSelected;
    TextStyle unselectedStyle=   Theme.of(context).brightness == Brightness.dark
    ? widget.styleEventDarkUnSelected: widget.styleEventLightUnSelected;     
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.006,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(46),
        color: widget.isSelected ? containerColor1 : AppColor.transparentColor,
        border: Border.all(
          color: containerColor1,
          width: 1,
        ),
      ),
      child: Text(
        widget.eventName,
        style: widget.isSelected?selectedStyle:unselectedStyle,
      ),
    );
  }
}
