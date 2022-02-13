import 'package:flutter/material.dart';


double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}


double getFullScreenHeight(context){
  return MediaQuery.of(context).size.height ;
}

double getScreenHeight(context) {

  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom ;
}

Orientation getScreenOrientation(context) {
  return MediaQuery.of(context).orientation ;
}