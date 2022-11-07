import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/screens/map_screen.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/small_elevated_card.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import '../../../../constants/assets_paths.dart';
import '../search_location_screen.dart';
import 'create_property_screen4.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePropertyScreen3 extends StatefulWidget {
  static const String id = "CreatePropertyScreen3";
  final Estate currentOffer;

  const CreatePropertyScreen3({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreen3State createState() => _CreatePropertyScreen3State();
}

class _CreatePropertyScreen3State extends State<CreatePropertyScreen3> with WidgetsBindingObserver {
  // Blocs And cubits:
  ChannelCubit nearbyPlacesCubit = ChannelCubit([]);
  late ChannelCubit mapButtonStateCubit;
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

    maximumCountOfNearbyPlaces =
        BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.maximumCountOfNearbyPlaces;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    mapButtonStateCubit = ChannelCubit(AppLocalizations.of(context)!.press_to_detect_position);
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: locationOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_3,
      body: SingleChildScrollView(
        child: Column(
          children: [
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.estate_location + " :",
              ),
            ),
            16.verticalSpace,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: propertyLocationErrorCubit,
              builder: (_, errorMessage) => TextField(
                onTap: () async {
                  selectedLocation = await Navigator.of(context).pushNamed(SearchLocationScreen.id)
                  as LocationViewer?;
                  if (selectedLocation != null) {
                    propertyPlaceController.text = selectedLocation!.getLocationName();
                    propertyLocationErrorCubit.setState(null);
                  } else {
                    propertyPlaceController.clear();
                  }
                },
                readOnly: true,
                controller: propertyPlaceController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: AppLocalizations.of(context)!.estate_location_hint,
                  isDense: true,
                ),
              ),
            ),
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.nearby_places +
                    " ( ${AppLocalizations.of(context)!.optional}) :",
              ),
            ),
            16.verticalSpace,
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
            12.verticalSpace,
            Row(
              children: [
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
                        controller: nearbyPlacesController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          isDense: true,
                        ),
                      );
                    },
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(999, 56.h),
                      primary: Theme.of(context).colorScheme.background,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      side: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                    ),
                    onPressed: () {
                      if (nearbyPlaces.length >= int.parse(maximumCountOfNearbyPlaces)) {
                        showNearbyPlacesFlutterToast();
                        return;
                      }
                      String newPlace = nearbyPlacesController.text;
                      // check if there are similar place :
                      if (nearbyPlaces.contains(newPlace)) {
                        FocusScope.of(context).unfocus();
                        MySnackBar.show(
                            context, AppLocalizations.of(context)!.place_already_existed);
                        return;
                      }
                      // check if there the value is empty :
                      if (newPlace.isEmpty) {
                        FocusScope.of(context).unfocus();
                        MySnackBar.show(context, AppLocalizations.of(context)!.enter_location_name);
                        return;
                      }
                      nearbyPlaces.add(newPlace);
                      nearbyPlacesController.clear();
                      nearbyPlacesCubit.setState(List.from(nearbyPlaces));
                      if (nearbyPlaces.length >= int.parse(maximumCountOfNearbyPlaces)) {
                        _isNearbyPlacesTextFieldEnableCubit.setState(false);
                      }
                    },
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.add,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Theme.of(context).colorScheme.onBackground),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.estate_position +
                    " ( ${AppLocalizations.of(context)!.optional}) :",
              ),
            ),
            12.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.estate_position_declaring,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            16.verticalSpace,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: mapButtonStateCubit,
              builder: (_, mapButtonContent) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(380.w, 56.h),
                    primary: Theme.of(context).colorScheme.background,
                    elevation: 0,
                    side: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                  ),
                  onPressed: () async {
                    mapButtonStateCubit.setState(AppLocalizations.of(context)!.loading_map);
                    _selectedPlace = await Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const MapSample()));
                    if (_selectedPlace != null) {
                      mapButtonStateCubit.setState(AppLocalizations.of(context)!.position_detected);
                    } else {
                      mapButtonStateCubit
                          .setState(AppLocalizations.of(context)!.press_to_detect_position);
                    }
                  },
                  child: Text(
                    mapButtonContent,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.4),
                  ),
                );
              },
            ),
            32.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
              child: Text(
                AppLocalizations.of(context)!.next,
              ),
              onPressed: () {
                if (!validateData()) return;

                String nearbyPlacesText = "";
                nearbyPlaces.asMap().forEach((index, element) {
                  nearbyPlacesText += element;
                  if (index != nearbyPlaces.length - 1) nearbyPlacesText += "|";
                });
                widget.currentOffer.locationId = selectedLocation!.id!;
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
            42.verticalSpace,
          ],
        ),
      ),
    );
  }


  showNearbyPlacesFlutterToast() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!
            .can_not_select_more_than_nearby_places(maximumCountOfNearbyPlaces));
  }

  bool validateData() {
    bool validation = true;

    if (selectedLocation == null) {
      propertyLocationErrorCubit.setState(AppLocalizations.of(context)!.this_field_is_required);
      validation = false;
    }

    return validation;
  }
}
