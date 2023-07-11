import 'package:flutter/material.dart';

import '../constants/constants.dart';
 
class MainListTile extends StatelessWidget {
  const MainListTile(
      {Key? key, required this.text, this.onPress, required this.icon, this.iconColor})
      : super(key: key);
  final String text;
  final Function()? onPress;
  final IconData icon;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,color: iconColor??DarkGray,),
      title: Text(
        text,
        style: text13DarkGrayFw500,
      ),
      onTap: onPress,
    );
  }
}
