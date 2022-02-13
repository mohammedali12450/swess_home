import 'package:flutter/cupertino.dart';
import 'package:swesshome/constants/enums.dart';

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double width = 0;
  if (orientation == Orientation.landscape) {
    width = mediaQueryData.size.height;
  } else{
    width = mediaQueryData.size.width;
  }
  if (width >= 950) return DeviceType.desktop;
  if (width >= 600) return DeviceType.tablet;
  return DeviceType.mobile;
}
