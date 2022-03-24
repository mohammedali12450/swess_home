import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/small_elevated_card.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import '../map_screen.dart';
import '../search_location_screen.dart';
import 'create_property_screen4.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatePropertyScreen3 extends StatefulWidget {
  static const String id = "CreatePropertyScreen3";
  final Estate currentOffer;

  const CreatePropertyScreen3({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreen3State createState() => _CreatePropertyScreen3State();
}

class _CreatePropertyScreen3State extends State<CreatePropertyScreen3> {
  // Blocs And cubits:
  ChannelCubit nearbyPlacesCubit = ChannelCubit([]);
  ChannelCubit mapButtonStateCubit = ChannelCubit("انقر لتحديد الموقع");
  ChannelCubit propertyLocationErrorCubit = ChannelCubit(null);
  final ChannelCubit _isNearbyPlacesTextFieldEnableCubit = ChannelCubit(true);
  late String maximumCountOfNearbyPlaces;

  // Controllers :
  TextEditingController propertyPlaceController = TextEditingController();
  TextEditingController nearbyPlacesController = TextEditingController();

  // Other :
  List<String> nearbyPlaces = [];
  Marker? _selectedPlace;
  LocationViewer? selectedLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initializing :

    maximumCountOfNearbyPlaces =
        BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.maximumCountOfNearbyPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: locationOutlineIconPath,
      headerText: "الخطوة الثالثة",
      body: SingleChildScrollView(
        child: Column(
          children: [
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                ":مكان العقار",
                textStyle: textStyling(S.s18, W.w6, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe16,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: propertyLocationErrorCubit,
              builder: (_, errorMessage) => TextField(
                onTap: () async {
                  selectedLocation = await Navigator.of(context).pushNamed(SearchLocationScreen.id)
                      as LocationViewer?;
                  if (selectedLocation != null) {
                    propertyPlaceController.text = selectedLocation!.getLocationName();
                    propertyLocationErrorCubit.setState(null);
                  }
                },
                readOnly: true,
                textDirection: TextDirection.rtl,
                style: textStyling(S.s17, W.w4, C.bl, fontFamily: F.roboto)
                    .copyWith(letterSpacing: 0.3),
                controller: propertyPlaceController,
                keyboardType: TextInputType.text,
                cursorColor: AppColors.black,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: "انقر لتحديد مكان العقار",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: textStyling(S.s14, W.w5, C.hint),
                  isDense: true,
                  border: kUnderlinedBorderBlack,
                  focusedBorder: kUnderlinedBorderBlack,
                ),
              ),
            ),
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                ":الأماكن القريبة من العقار (اختياري)",
                textStyle: textStyling(S.s18, W.w6, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe16,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: nearbyPlacesCubit,
              builder: (_, nearbyPlacesList) {
                return Wrap(
                  runSpacing: 5,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: nearbyPlacesList
                      .map<Widget>(
                        (place) => SmallElevatedCard(
                          content: place,
                          onDelete: (content) {
                            nearbyPlaces.remove(content);
                            nearbyPlacesCubit.setState(List.from(nearbyPlaces));
                            if (!_isNearbyPlacesTextFieldEnableCubit.state) {
                              _isNearbyPlacesTextFieldEnableCubit.setState(true);
                            }
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
            kHe12,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MyButton(
                    onPressed: () {
                      if (nearbyPlaces.length >= int.parse(maximumCountOfNearbyPlaces)) {
                        showNearbyPlacesFlutterToast();
                        return;
                      }

                      String newPlace = nearbyPlacesController.text;
                      // check if there are similar place :
                      if (nearbyPlaces.contains(newPlace)) {
                        FocusScope.of(context).unfocus();
                        MySnackBar.show(context, "!! هذا المكان موجود مسبقاً");
                        return;
                      }
                      // check if there the value is empty :
                      if (newPlace.isEmpty) {
                        FocusScope.of(context).unfocus();
                        MySnackBar.show(context, "!! أدخل اسم المكان");
                        return;
                      }
                      nearbyPlaces.add(newPlace);
                      nearbyPlacesController.clear();
                      nearbyPlacesCubit.setState(List.from(nearbyPlaces));
                      if (nearbyPlaces.length >= int.parse(maximumCountOfNearbyPlaces)) {
                        _isNearbyPlacesTextFieldEnableCubit.setState(false);
                      }
                    },
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.black, width: 0.5),
                    borderRadius: 8,
                    child: ResText(
                      'إضافة',
                      textStyle: textStyling(S.s16, W.w5, C.bl).copyWith(height: 1.8),
                    ),
                    height: Res.height(56),
                  ),
                ),
                kWi12,
                Expanded(
                  flex: 3,
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: _isNearbyPlacesTextFieldEnableCubit,
                    builder: (_, isEnabled) {
                      return TextField(
                        readOnly: !isEnabled,
                        onTap: (!isEnabled)
                            ? () {
                          showNearbyPlacesFlutterToast();
                        }
                            : null,
                        textDirection: TextDirection.rtl,
                        style: textStyling(S.s17, W.w4, C.bl, fontFamily: F.roboto)
                            .copyWith(letterSpacing: 0.3),
                        controller: nearbyPlacesController,
                        cursorColor: AppColors.black,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: kUnderlinedBorderBlack,
                          focusedBorder: kUnderlinedBorderBlack,
                          isDense: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                ":موقع العقار (اختياري)",
                textStyle: textStyling(S.s18, W.w6, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe12,
            SizedBox(
              width: inf,
              child: ResText(
                ".يمكنك تزويد موقع العقار لمعلومات أكثر دقة",
                textStyle: textStyling(S.s14, W.w5, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe16,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: mapButtonStateCubit,
              builder: (_, mapButtonContent) {
                return MyButton(
                  onPressed: () async {
                    mapButtonStateCubit.setState("...جاري تحميل الخريطة");
                    _selectedPlace = await Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const MapSample()));
                    if (_selectedPlace != null) {
                      mapButtonStateCubit.setState("تم تحديد الموقع");
                    } else {
                      mapButtonStateCubit.setState("انقر لتحديد الموقع");
                    }
                  },
                  child: ResText(
                    mapButtonContent,
                    textStyle: textStyling(S.s16, W.w5, C.c2),
                  ),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.black),
                  borderRadius: 8,
                  width: Res.width(300),
                  shadow: [
                    BoxShadow(
                        color: AppColors.black.withOpacity(0.20),
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 1),
                  ],
                );
              },
            ),
            kHe36,
            MyButton(
              child: ResText(
                "التالي",
                textStyle: textStyling(S.s16, W.w5, C.wh),
              ),
              width: Res.width(240),
              height: Res.height(56),
              color: AppColors.secondaryColor,
              onPressed: () {
                if (!validateData()) return;

                String nearbyPlacesText = "";
                nearbyPlaces.asMap().forEach((index, element) {
                  nearbyPlacesText += element;
                  if (index != nearbyPlaces.length - 1) nearbyPlacesText += "|";
                });
                widget.currentOffer.locationId = selectedLocation!.id;
                widget.currentOffer.nearbyPlaces = nearbyPlacesText;
                widget.currentOffer.latitude =
                    (_selectedPlace != null) ? _selectedPlace!.position.latitude.toString() : null;
                widget.currentOffer.longitude =
                    (_selectedPlace != null) ? _selectedPlace!.position.longitude.toString() : null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePropertyScreen4(currentOffer: widget.currentOffer),
                  ),
                );
              },
            ),
            kHe12,
          ],
        ),
      ),
    );
  }

  showNearbyPlacesFlutterToast() {
    Fluttertoast.showToast(
        msg: " لا يمكنك تحديد أكثر من " + maximumCountOfNearbyPlaces + " أماكن قريبة ");
  }

  bool validateData() {
    bool validation = true;

    if (selectedLocation == null) {
      propertyLocationErrorCubit.setState("هذا الحقل مطلوب");
      validation = false;
    }

    return validation;
  }
}
