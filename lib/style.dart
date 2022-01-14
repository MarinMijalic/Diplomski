import 'package:flutter/material.dart';

const SmallestTextSize = 12.0;
const SmallTextSize = 14.0;
const NormalTextSize = 16.0;
const BigTextSize = 20.0;
const BiggestTextsize = 24.0;
const String FontName = 'Roboto';

MaterialColor PrimaryColor = const MaterialColor(0XFF39B54A, const{
  50: const Color.fromRGBO(57,181,74, .1),
  100: const Color.fromRGBO(57,181,74, .2),
  200: const Color.fromRGBO(57,181,74, .3),
  300: const Color.fromRGBO(57,181,74, .4),
  400: const Color.fromRGBO(57,181,74, .5),
  500: const Color.fromRGBO(57,181,74, .6),
  600: const Color.fromRGBO(57,181,74, .7),
  700: const Color.fromRGBO(57,181,74, .8),
  800: const Color.fromRGBO(57,181,74, .9),
  900: const Color.fromRGBO(57,181,74, 1),
});

const HintTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  color: Color.fromRGBO(85, 85, 85, 1),
);

const RegularButtonTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w600,
  fontSize: NormalTextSize,
  color: Colors.white,
);
const DrawerTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w400,
  fontSize: NormalTextSize,
  color: Colors.white,
);

const FormTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w400,
  fontSize: NormalTextSize,
  color: Colors.black,
);

const MediumGreenTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w400,
  fontSize: NormalTextSize,
  color: Color.fromRGBO(57,181,74, 1),
);
const MediumRedTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w400,
  fontSize: NormalTextSize,
  color: Colors.red,
);
const AppBarTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w600,
  fontSize: BigTextSize,
  color: Colors.white,
);

const GridTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w600,
  fontSize: NormalTextSize,
  color: Colors.white,
);
const GridTabletTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w600,
  fontSize: BigTextSize,
  color: Colors.white,
);

const BigGreenTextStyle = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w600,
  fontSize: BigTextSize,
  color: Color.fromRGBO(57,181,74, 1),
);