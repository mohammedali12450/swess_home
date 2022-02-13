import 'package:swesshome/constants/design_constants.dart';

class Res{
  static double width(width) {
    return (width / kMockupScreenWidth) * screenWidth ;
  }

  static double height(height) {
    return (height / kMockupScreenHeight) * screenHeight ;
  }

  static double getImageScale()
  {
    return kMockupScreenWidth / screenWidth ;
  }

  static double getTextScale()
  {
    var scale = screenWidth / kMockupScreenWidth ;
    return scale ;
  }
}