import 'package:flutter/material.dart';
  
const Color PrimaryColor = Color.fromARGB(255, 239, 40, 76);
const Color PrimaryColorMuchDark = Color.fromARGB(255, 216, 15, 52);
 const Color YellowColor = Color.fromARGB(255, 255, 166, 0);

const Color Transparent = Colors.transparent;
 const Color DarkGray = Color.fromARGB(255, 121, 121, 121);
const Color MuchDarkGray = Color.fromARGB(255, 52, 47, 57);
const Color LightGray = Color.fromARGB(255, 200, 200, 200);
const Color MuchLightGray = Color.fromARGB(255, 237, 230, 237);
const Color MuchLightGreen = Color.fromARGB(255, 135, 198, 191);

const Color kTextColor = Color.fromARGB(255, 185, 185, 185);
const Color aWhite = Color(0xFFFFFFFF);
const Color aBlack = Color(0xFF000000);
const Color transparentBlack = Color.fromARGB(92, 0, 0, 0);
const Color transparentWhite = Color.fromARGB(173, 255, 255, 255);

 

final TextStyle text18lightFw500 = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: aWhite,
);

final TextStyle text16LightFw500 = const TextStyle(
  fontSize:  16,
  fontWeight: FontWeight.w500,
  color: aWhite,
);

final TextStyle text18DarkFw700 = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: aBlack,
);
final TextStyle text27DarkGrayFw800 = TextStyle(
  fontSize: 27.5 ,
  fontWeight: FontWeight.w800,
  color: DarkGray.withOpacity(0.8),
);
final TextStyle text27DarkFw800 = const TextStyle(
  fontSize:  27.5 ,
  fontWeight: FontWeight.w800,
  color: aBlack,
);
 

const TextStyle text12LightFw400 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: aWhite,
);
 
const TextStyle text12LightGrayFw400LineThrough = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: LightGray,
    decoration: TextDecoration.lineThrough);

const TextStyle text12LightGray = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: LightGray,
);

const TextStyle text13LightFw500 = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: aWhite,
);
 

const TextStyle text13DarkGrayFw500 = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: DarkGray,
);

const TextStyle text13LightGrayFw500 = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: LightGray,
);

const BoxShadow boxShadow1 = BoxShadow(
  offset: Offset(0, 5),
  spreadRadius: 1,
  blurRadius: 17,
  color: LightGray,
);
const defaultDuration1sec = Duration(seconds: 1);
 const defaultDuration0sec = Duration(seconds: 0);
const defaultDuration2sec = Duration(seconds: 2);
const defaultDuration3sec = Duration(seconds: 3);

EdgeInsets paddingMarginAll20 =
    const EdgeInsets.all( 20 );
EdgeInsets paddingMarginAll15 = const EdgeInsets.all(15);
EdgeInsets paddingMarginAll12 = const EdgeInsets.all( 12 );
EdgeInsets paddingMarginTLR15 = const EdgeInsets.only(
    top: 15,
    right: 15,
    left: 15);
 
EdgeInsets paddingMarginL15 =
    const EdgeInsets.only(left: 15);

EdgeInsets paddingMarginTB15 = const EdgeInsets.symmetric(
  vertical: 15,
);

EdgeInsets paddingMarginAll8 = const EdgeInsets.all(8);
EdgeInsets paddingMarginAll5 = const EdgeInsets.all(5);

EdgeInsets paddingMarginLR15 =
    const EdgeInsets.symmetric(horizontal:   15);
EdgeInsets paddingMarginLR12 =
    const EdgeInsets.symmetric(horizontal: 12);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kTextColor),
  );
}

SizedBox sizedBox = const SizedBox();
BorderRadius borderRadius50 = BorderRadius.circular(50);

BorderRadius borderRadiusLR15 = const BorderRadius.only(
  topLeft: Radius.circular(15),
  topRight: Radius.circular(15),
);
BorderRadius borderRadiusBottomLR20 = const BorderRadius.only(
  bottomLeft: Radius.circular( 20 ),
  bottomRight: Radius.circular( 20 ),
);

BorderRadius borderRadius13 = BorderRadius.circular(13);
BorderRadius borderRadius15 = BorderRadius.circular(15);
BorderRadius borderRadius18 = BorderRadius.circular(18);
BorderRadius borderRadius10 = BorderRadius.circular(10);
BorderRadius borderRadius8 = BorderRadius.circular(8);
 
Border border0by8lightGray = Border.all(width: .65, color: LightGray);
