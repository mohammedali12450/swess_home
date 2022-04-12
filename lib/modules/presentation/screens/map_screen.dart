import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/popup_tutorial_messages/map_popup_message_tutorial.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

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
  late CameraPosition initialPosition;

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

    if (BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.isForStore) {
      initialPosition = const CameraPosition(
        target: LatLng(kInitLatitudeLebanon, kInitLongitudeLebanon),
        zoom: 10,
      );
    } else {
      initialPosition = const CameraPosition(
        target: LatLng(kInitLatitudeSyria, kInitLongitudeSyria),
        zoom: 10,
      );
    }
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
          showConfirmationDialog();
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
                  markers.clear();
                  markers.add(newMarker);
                  selectedMarker = newMarker;
                }
                return GoogleMap(
                  onTap: (position) {
                    if (widget.isView) return;
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.estate_position_selected);
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
                  initialCameraPosition: initialPosition,
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
                        SizedBox(
                          width: 1.sw,
                          height: 1.sh,
                        ),
                      // Floating buttons:
                      Positioned.fill(
                        bottom: 16.h,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(),
                                child: FloatingActionButton(
                                  heroTag: "btn2",
                                  child: Icon(
                                    Icons.remove,
                                    size: 32.w,
                                    color: AppColors.white,
                                  ),
                                  onPressed: () {
                                    // zoom in:
                                    if (googleMapController == null) return;
                                    googleMapController!.animateCamera(
                                      CameraUpdate.zoomOut(),
                                    );
                                  },
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              12.horizontalSpace,
                              Container(
                                width: 108.w,
                                height: 108.w,
                                decoration: const BoxDecoration(),
                                child: FloatingActionButton(
                                  heroTag: "btn3",
                                  child: Icon(
                                    Icons.check,
                                    size: 36.w,
                                    color: AppColors.black,
                                  ),
                                  onPressed: () {
                                    if (selectedMarker == null) {
                                      Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!
                                              .select_position_by_pressing_on_map,
                                          toastLength: Toast.LENGTH_LONG);
                                      return;
                                    }
                                    Navigator.pop(context, selectedMarker);
                                  },
                                  backgroundColor: AppColors.secondaryColor,
                                ),
                              ),
                              12.horizontalSpace,
                              Container(
                                decoration: const BoxDecoration(),
                                child: FloatingActionButton(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  heroTag: "btn1",
                                  child: Icon(
                                    Icons.add,
                                    size: 32.w,
                                    color: AppColors.white,
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
                              title: AppLocalizations.of(context)!.zoom_in_zoom_out,
                              content: AppLocalizations.of(context)!.zoom_in_out_map_dialog,
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
                              title: AppLocalizations.of(context)!.moving,
                              content: AppLocalizations.of(context)!.navigate_map_dialog,
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
                              title: AppLocalizations.of(context)!.estate_position_selecting,
                              content: AppLocalizations.of(context)!.locate_map_dialog,
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
                              title: AppLocalizations.of(context)!.final_step,
                              content: AppLocalizations.of(context)!.finish_select_map_dialog,
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
    showWonderfulAlertDialog(context, AppLocalizations.of(context)!.confirmation,
        AppLocalizations.of(context)!.discard_location_confirmation,
        removeDefaultButton: true,
        dialogButtons: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(100.w, 56.h),
            ),
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
            child: Text(
              AppLocalizations.of(context)!.yes,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(100.w, 56.h),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.no,
            ),
          ),
        ]);
  }
}
