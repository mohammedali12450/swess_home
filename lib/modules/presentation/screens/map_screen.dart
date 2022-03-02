import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/popup_tutorial_messages/map_popup_message_tutorial.dart';
import 'package:swesshome/utils/helpers/my_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

enum TutorialStep {
  none,
  zooming,
  moving,
  select,
  finish,
}

class MapSample extends StatefulWidget {
  static const String id = "MapSample";

  final List<Marker>? initialMarkers;
  final bool isView;

  const MapSample({Key? key, this.initialMarkers, this.isView = false}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // Blocs and cubits

  ChannelCubit tutorialStepCubit = ChannelCubit(TutorialStep.none);
  ChannelCubit mapMarkersCubit = ChannelCubit(null);

  // Map Variables:
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? googleMapController;
  static const CameraPosition damascusPosition = CameraPosition(
    target: LatLng(kInitLatitude, kInitLongitude),
    zoom: 10,
  );
  Marker? selectedMarker;
  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isView) {
      showTutorial();
    }
    if (widget.initialMarkers != null) markers.addAll(widget.initialMarkers!);
  }

  void showTutorial() async {
    // check if map tutorial passed!!
    bool? isTutorialPassed = ApplicationSharedPreferences.getMapTutorialPassState();
    if (isTutorialPassed) return;
    await Future.delayed(
      const Duration(seconds: 3),
    );
    tutorialStepCubit.setState(TutorialStep.zooming);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.isView) {
          await showMyAlertDialog(
            "تأكيد",
            "هل تريد إلغاء تحديد الموقع",
            context,
            actions: [
              DialogAction(
                content: "تأكيد",
                onPressed: (context) {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              ),
              DialogAction(
                content: "إلغاء",
                onPressed: (dialogContext) {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Map :
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: mapMarkersCubit,
              builder: (_, newMarker) {
                // initState
                if (newMarker != null) {
                  markers.add(newMarker);
                  selectedMarker = newMarker;
                }
                return GoogleMap(
                  onTap: (position) {
                    Fluttertoast.showToast(msg: "تم تحديد مكان العقار");
                    mapMarkersCubit.setState(
                      Marker(
                        position: position,
                        markerId: MarkerId((markers.length + 1).toString()),
                      ),
                    );
                  },
                  mapType: MapType.normal,
                  markers: markers,
                  zoomControlsEnabled: false,
                  initialCameraPosition: damascusPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    googleMapController = controller;
                  },
                );
              },
            ),
            if (!widget.isView)
              BlocBuilder(
                bloc: tutorialStepCubit,
                builder: (_, tutorialStep) {
                  return Stack(
                    children: [
                      // weak black background :
                      if (tutorialStep != TutorialStep.none)
                        Container(
                          width: screenWidth,
                          height: fullScreenHeight,
                          color: black.withOpacity(0.72),
                        ),
                      // Floating buttons:
                      Positioned.fill(
                        bottom: Res.height(16),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: kSmallAllPadding,
                                decoration: BoxDecoration(
                                  border: (tutorialStep == TutorialStep.zooming)
                                      ? Border.all(color: white, width: 2)
                                      : Border.all(color: Colors.transparent, width: 2),
                                ),
                                child: FloatingActionButton(
                                  heroTag: "btn2",
                                  backgroundColor: secondaryColor,
                                  child: Icon(
                                    Icons.remove,
                                    color: white,
                                    size: Res.width(32),
                                  ),
                                  onPressed: () {
                                    // zoom in:
                                    if (googleMapController == null) return;
                                    googleMapController!.animateCamera(
                                      CameraUpdate.zoomOut(),
                                    );
                                  },
                                ),
                              ),
                              kWi8,
                              Container(
                                padding: kSmallAllPadding,
                                width: Res.width(108),
                                height: Res.width(108),
                                decoration: BoxDecoration(
                                  border: (tutorialStep == TutorialStep.finish)
                                      ? Border.all(color: white, width: 2)
                                      : Border.all(color: Colors.transparent, width: 2),
                                ),
                                child: FloatingActionButton(
                                  heroTag: "btn3",
                                  backgroundColor: thirdColor,
                                  child: Icon(
                                    Icons.check,
                                    color: secondaryColor,
                                    size: Res.width(36),
                                  ),
                                  onPressed: () {
                                    if (selectedMarker == null) {
                                      Fluttertoast.showToast(
                                          msg: "قم بتحديد مكان العقار عن طريق النقر على الخريطة!",
                                          toastLength: Toast.LENGTH_LONG);
                                      return;
                                    }
                                    Navigator.pop(context, selectedMarker);
                                  },
                                ),
                              ),
                              kWi8,
                              Container(
                                padding: kSmallAllPadding,
                                decoration: BoxDecoration(
                                  border: (tutorialStep == TutorialStep.zooming)
                                      ? Border.all(color: white, width: 2)
                                      : Border.all(color: Colors.transparent, width: 2),
                                ),
                                child: FloatingActionButton(
                                  heroTag: "btn1",
                                  backgroundColor: secondaryColor,
                                  child: Icon(
                                    Icons.add,
                                    color: white,
                                    size: Res.width(32),
                                  ),
                                  onPressed: () {
                                    // zoom in:
                                    if (googleMapController == null) return;
                                    googleMapController!.animateCamera(
                                      CameraUpdate.zoomIn(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Zoom message :
                      if (tutorialStep == TutorialStep.zooming)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: MapPopupMessageTutorial(
                              onPressed: () {
                                tutorialStepCubit.setState(TutorialStep.moving);
                              },
                              title: "تكبير / تصغير",
                              bottomRightRadius: 0,
                              content: zoomingTutorialContent,
                            ),
                          ),
                        ),
                      // Move message :
                      if (tutorialStep == TutorialStep.moving)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: MapPopupMessageTutorial(
                              onPressed: () {
                                tutorialStepCubit.setState(TutorialStep.select);
                              },
                              title: "تحريك",
                              content: movingTutorialContent,
                            ),
                          ),
                        ),
                      // Select message :
                      if (tutorialStep == TutorialStep.select)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: MapPopupMessageTutorial(
                              onPressed: () {
                                tutorialStepCubit.setState(TutorialStep.finish);
                              },
                              title: "تحديد مكان العقار",
                              content: selectTutorialContent,
                            ),
                          ),
                        ),
                      // Finish message :
                      if (tutorialStep == TutorialStep.finish)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: MapPopupMessageTutorial(
                              onPressed: () {
                                tutorialStepCubit.setState(TutorialStep.none);
                                // Change shared preferences map tutorial
                                ApplicationSharedPreferences.setMapTutorialPassState(true);
                              },
                              title: "تثبيت المكان",
                              content: finishTutorialContent,
                              bottomRightRadius: 0,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future showConfirmationDialog() async {
    Widget cancelButton = TextButton(
      child: const Text("إلغاء"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("تأكيد"),
      onPressed: () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      },
    );

    if (Platform.isIOS) {
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: const Text("تنبيه"),
        content: const Text("هل تريد إنهاء تحديد المكان"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    if (Platform.isAndroid) {
      AlertDialog alert = AlertDialog(
        title: const Text("تنبيه"),
        content: const Text("هل تريد إنهاء تحديد المكان"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}
