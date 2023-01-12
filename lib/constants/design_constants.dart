import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  width: 4.w,
);
SizedBox kWi8 = SizedBox(
  width: 8.w,
);
SizedBox kWi12 = SizedBox(
  width: 12.w,
);
SizedBox kWi16 = SizedBox(
  width: 16.w,
);
SizedBox kWi20 = SizedBox(
  width: 20.w,
);
SizedBox kWi24 = SizedBox(
  width: 24.w,
);
SizedBox kWi28 = SizedBox(
  width: 28.w,
);
SizedBox kWi32 = SizedBox(
  width: 32.w,
);
SizedBox kWi36 = SizedBox(
  width: 36.w,
);
SizedBox kWi40 = SizedBox(
  width: 40.w,
);
SizedBox kWi44 = SizedBox(
  width: 44.w,
);
SizedBox kHe4 = SizedBox(
  height: 4.h,
);
SizedBox kHe8 = SizedBox(
  height: 8.h,
);
SizedBox kHe12 = SizedBox(
  height: 12.h,
);
SizedBox kHe16 = SizedBox(
  height: 16.h,
);
SizedBox kHe20 = SizedBox(
  height: 20.h,
);
SizedBox kHe24 = SizedBox(
  height: 24.h,
);
SizedBox kHe28 = SizedBox(
  height: 28.h,
);
SizedBox kHe32 = SizedBox(
  height: 32.h,
);
SizedBox kHe36 = SizedBox(
  height: 36.h,
);
SizedBox kHe40 = SizedBox(
  height: 40.h,
);
SizedBox kHe44 = SizedBox(
  height: 44.h,
);
SizedBox kHe50 = SizedBox(
  height: 50.h,
);
SizedBox kHe60 = SizedBox(
  height: 60.h,
);

EdgeInsets kTinyAllPadding = EdgeInsets.all(kTinyPadding.w);
EdgeInsets kSmallAllPadding = EdgeInsets.all(kSmallPadding.w);
EdgeInsets kMediumAllPadding = EdgeInsets.all(kMediumPadding.w);
EdgeInsets kLargeAllPadding = EdgeInsets.all(kLargePadding.w);
EdgeInsets kXLargeAllPadding = EdgeInsets.all(kXLargePadding.w);
EdgeInsets kXXLargeAllPadding = EdgeInsets.all(kXXLargePadding.w);
EdgeInsets kHugeAllPadding = EdgeInsets.all(kHugePadding.w);
EdgeInsets kSmallSymWidth =
    EdgeInsets.symmetric(horizontal: kSmallPadding.w, vertical: kTinyPadding.h);
EdgeInsets kMediumSymWidth =
    EdgeInsets.symmetric(horizontal: kMediumPadding.w, vertical: kTinyPadding.h);
EdgeInsets kLargeSymWidth =
    EdgeInsets.symmetric(horizontal: kXLargePadding.w, vertical: kSmallPadding.h);
EdgeInsets kSmallSymHeight =
    EdgeInsets.symmetric(horizontal: kTinyPadding.w, vertical: kSmallPadding.h);
EdgeInsets kMediumSymHeight =
    EdgeInsets.symmetric(horizontal: kTinyPadding.w, vertical: kMediumPadding.h);
EdgeInsets kLargeSymHeight =
    EdgeInsets.symmetric(horizontal: kSmallPadding.w, vertical: kLargePadding.h);

List<Positioned> kBackgroundDrawings(BuildContext context) => [
  Positioned(
    right: 30.w,
    top: 50.h,
    child: Transform.rotate(
      angle: -0.25,
      child: Icon(
        Icons.home_outlined,
        size: 70,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: 30.w,
    top: 200.h,
    child: Transform.rotate(
      angle: 0.25,
      child: Icon(
        Icons.maps_home_work,
        size: 70,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: 30.w,
    bottom: 150.h,
    child: Transform.rotate(
      angle: -0.4,
      child: Icon(
        Icons.library_add_check_outlined,
        size: 50,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    right: 30.w,
    bottom: 250.h,
    child: Transform.rotate(
      angle: 0.2,
      child: Icon(
        Icons.apartment,
        size: 60,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    left: 30.w,
    top: 500.h,
    child: Transform.rotate(
      angle: -0.35,
      child: Icon(
        Icons.map_outlined,
        size: 70,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
      ),
    ),
  ),
  Positioned(
    right: 30.w,
    top: 350.h,
    child: Transform.rotate(
      angle: 0.24,
      child: Icon(
        Icons.payments_outlined,
        size: 70,
        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04),
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

BoxShadow veryLowElevation = BoxShadow(
    color: AppColors.black.withOpacity(0.04),
    offset: const Offset(0, 0),
    blurRadius: 6,
    spreadRadius: 1);
BoxShadow lowElevation = BoxShadow(
    color: AppColors.black.withOpacity(0.16),
    offset: const Offset(0, 0),
    blurRadius: 6,
    spreadRadius: 2);
BoxShadow lowWhiteElevation = BoxShadow(
    color: AppColors.black.withOpacity(0.16),
    offset: const Offset(0, 0),
    blurRadius: 6,
    spreadRadius: 2);

const BorderRadius lowBorderRadius = BorderRadius.all(Radius.circular(8));
const BorderRadius medBorderRadius = BorderRadius.all(Radius.circular(16));
const BorderRadius highBorderRadius = BorderRadius.all(Radius.circular(24));
