import 'package:flutter/material.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'colors.dart';

/* Padding constants */
const double kTinyPadding = 8;

const double kSmallPadding = 12;

const double kMediumPadding = 16;

const double kLargePadding = 20;

const double kXLargePadding = 24;

const double kXXLargePadding = 28;

const double kHugePadding = 32;

const double inf = double.infinity;

SizedBox kWi4 = SizedBox(
  width: Res.width(4),
);
SizedBox kWi8 = SizedBox(
  width: Res.width(8),
);
SizedBox kWi12 = SizedBox(
  width: Res.width(12),
);
SizedBox kWi16 = SizedBox(
  width: Res.width(16),
);
SizedBox kWi20 = SizedBox(
  width: Res.width(20),
);
SizedBox kWi24 = SizedBox(
  width: Res.width(24),
);
SizedBox kWi28 = SizedBox(
  width: Res.width(28),
);
SizedBox kWi32 = SizedBox(
  width: Res.width(32),
);
SizedBox kWi36 = SizedBox(
  width: Res.width(32),
);
SizedBox kWi40 = SizedBox(
  width: Res.width(32),
);
SizedBox kWi44 = SizedBox(
  width: Res.width(32),
);
SizedBox kHe4 = SizedBox(
  height: Res.height(4),
);
SizedBox kHe8 = SizedBox(
  height: Res.height(8),
);
SizedBox kHe12 = SizedBox(
  height: Res.height(12),
);
SizedBox kHe16 = SizedBox(
  height: Res.height(16),
);
SizedBox kHe20 = SizedBox(
  height: Res.height(20),
);
SizedBox kHe24 = SizedBox(
  height: Res.height(24),
);
SizedBox kHe28 = SizedBox(
  height: Res.height(28),
);
SizedBox kHe32 = SizedBox(
  height: Res.height(32),
);
SizedBox kHe36 = SizedBox(
  height: Res.height(32),
);
SizedBox kHe40 = SizedBox(
  height: Res.height(32),
);
SizedBox kHe44 = SizedBox(
  height: Res.height(32),
);

EdgeInsets kTinyAllPadding = EdgeInsets.all(Res.width(kTinyPadding));
EdgeInsets kSmallAllPadding = EdgeInsets.all(Res.width(kSmallPadding));
EdgeInsets kMediumAllPadding = EdgeInsets.all(Res.width(kMediumPadding));
EdgeInsets kLargeAllPadding = EdgeInsets.all(Res.width(kLargePadding));
EdgeInsets kXLargeAllPadding = EdgeInsets.all(Res.width(kXLargePadding));
EdgeInsets kXXLargeAllPadding = EdgeInsets.all(Res.width(kXXLargePadding));
EdgeInsets kHugeAllPadding = EdgeInsets.all(Res.width(kHugePadding));
EdgeInsets kSmallSymWidth = EdgeInsets.symmetric(
    horizontal: Res.width(kSmallPadding), vertical: Res.height(kTinyPadding));
EdgeInsets kMediumSymWidth = EdgeInsets.symmetric(
    horizontal: Res.width(kMediumPadding), vertical: Res.height(kTinyPadding));
EdgeInsets kLargeSymWidth = EdgeInsets.symmetric(
    horizontal: Res.width(kXLargePadding), vertical: Res.height(kSmallPadding));
EdgeInsets kSmallSymHeight = EdgeInsets.symmetric(
    horizontal: Res.width(kTinyPadding), vertical: Res.height(kSmallPadding));
EdgeInsets kMediumSymHeight = EdgeInsets.symmetric(
    horizontal: Res.width(kTinyPadding), vertical: Res.height(kMediumPadding));
EdgeInsets kLargeSymHeight = EdgeInsets.symmetric(
    horizontal: Res.width(kSmallPadding), vertical: Res.height(kLargePadding));

/* Design Constants */
const double kMockupScreenWidth = 428;
const double kMockupScreenHeight = 926;
double screenWidth = -1;
double screenHeight = -1;
double fullScreenHeight = -1;

List<Positioned> kBackgroundDrawings = [
  Positioned(
    right: Res.width(30),
    top: Res.height(50),
    child: Transform.rotate(
      angle: -0.25,
      child: Icon(
        Icons.home_outlined,
        size: 70,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: Res.width(30),
    top: Res.height(200),
    child: Transform.rotate(
      angle: 0.25,
      child: Icon(
        Icons.maps_home_work,
        size: 70,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: Res.width(30),
    top: Res.height(800),
    child: Transform.rotate(
      angle: -0.4,
      child: Icon(
        Icons.library_add_check_outlined,
        size: 50,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    right: Res.width(30),
    top: Res.height(650),
    child: Transform.rotate(
      angle: 0.2,
      child: Icon(
        Icons.apartment,
        size: 60,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: Res.width(30),
    top: Res.height(500),
    child: Transform.rotate(
      angle: -0.35,
      child: Icon(
        Icons.map_outlined,
        size: 70,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    right: Res.width(30),
    top: Res.height(350),
    child: Transform.rotate(
      angle: 0.24,
      child: Icon(
        Icons.payments_outlined,
        size: 70,
        color: AppColors.secondaryColor.withOpacity(0.04),
      ),
    ),
  ),
];

const kOutlinedBorderRed = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(color: Colors.red),
);
const kOutlinedBorderBlack = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(color: Colors.black),
);
OutlineInputBorder kOutlinedBorderGrey = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(color: AppColors.black.withOpacity(0.4)),
);
const kUnderlinedBorderRed = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
);
const kUnderlinedBorderWhite = UnderlineInputBorder(
  borderSide: BorderSide(color: AppColors.white),
);
const kUnderlinedBorderBlack = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
);
UnderlineInputBorder kUnderlinedBorderGrey = UnderlineInputBorder(
  borderSide: BorderSide(color: AppColors.black.withOpacity(0.4)),
);

BoxShadow veryLowElevation = BoxShadow(color: AppColors.black.withOpacity(0.08),offset: const Offset(0, 0) , blurRadius: 6 , spreadRadius: 1);
BoxShadow lowElevation = BoxShadow(color: AppColors.black.withOpacity(0.16),offset: const Offset(0, 0) , blurRadius: 6 , spreadRadius: 2);
BoxShadow lowWhiteElevation = BoxShadow(color: AppColors.black.withOpacity(0.16),offset: const Offset(0, 0) , blurRadius: 6 , spreadRadius: 2);

const BorderRadius lowBorderRadius = BorderRadius.all(Radius.circular(8));
const BorderRadius medBorderRadius = BorderRadius.all(Radius.circular(16));
const BorderRadius highBorderRadius = BorderRadius.all(Radius.circular(24));