import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/build_images_selectors.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_screen_finish.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'create_property_screen6.dart';
import 'package:intl/intl.dart' as intl;
import 'image_count_validate.dart';

class CreatePropertyScreen5 extends StatefulWidget {
  static const String id = "CreatePropertyScreen5";

  final Estate currentOffer;

  const CreatePropertyScreen5({Key? key, required this.currentOffer})
      : super(key: key);

  @override
  _CreatePropertyScreen5State createState() => _CreatePropertyScreen5State();
}

class _CreatePropertyScreen5State extends State<CreatePropertyScreen5> {
  List<File>? propertyImages;

  List<File>? streetPropertyImages;

  List<File>? floorPlanPropertyImages;

  TextEditingController descriptionController = TextEditingController();

  bool isLands = false;
  bool isShops = false;
  bool isCompressing = false;

  late SystemVariables _systemVariables;
  ChannelCubit textDirectionCubit = ChannelCubit(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLands = widget.currentOffer.estateType!.id == landsPropertyTypeNumber;
    isShops = widget.currentOffer.estateType!.id == shopsPropertyTypeNumber;
    _systemVariables =
        BlocProvider.of<SystemVariablesBloc>(context).systemVariables!;
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath:
          (isLands || isShops) ? documentOutlineIconPath : imageOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_5,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLands || isShops) ...[
              24.verticalSpace,
              SizedBox(
                width: 1.sw,
                child: Text(AppLocalizations.of(context)!.estate_description +
                    " ( ${AppLocalizations.of(context)!.optional} ) :"),
              ),
              16.verticalSpace,
              SizedBox(
                width: 1.sw,
                height: 200.h,
                child: BlocBuilder<ChannelCubit, dynamic>(
                  bloc: textDirectionCubit,
                  builder: (_, text) {
                    return TextField(
                      textDirection: (text == null)
                          ? null
                          : intl.Bidi.detectRtlDirectionality(text)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      controller: descriptionController,
                      maxLines: 8,
                      maxLength: 600,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .estate_description_hint,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.48),
                              width: 0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        textDirectionCubit.setState(value);
                      },
                    );
                  },
                ),
              ),
            ],
            if (!isLands && !isShops)
              buildImagesSelectors(
                onPropertyImagesSelected: (images) {
                  propertyImages = (images == null || images.isEmpty)
                      ? null
                      : images.map((e) => e as File).toList();
                },
                onStreetImagesSelected: (images) {
                  streetPropertyImages = (images == null || images.isEmpty)
                      ? null
                      : images.map((e) => e as File).toList();
                },
                onFloorPlanImagesSelected: (images) {
                  floorPlanPropertyImages = (images == null || images.isEmpty)
                      ? null
                      : images.map((e) => e as File).toList();
                },
                compressStateListener: (compressState) {
                  isCompressing = compressState;
                },
                maximumCountOfEstateImages:
                    int.parse(_systemVariables.maximumCountOfEstateImages),
                maximumCountOfStreetImages:
                    int.parse(_systemVariables.maximumCountOfStreetImages),
                maximumCountOfFloorPlanImages:
                    int.parse(_systemVariables.maximumCountOfFloorPlanImages),
                minimumCountOfEstateImages:
                    _systemVariables.minimumCountOfEstateImages,
              ),
            32.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
              child: Text(
                (isLands || isShops)
                    ? AppLocalizations.of(context)!.create_estate
                    : AppLocalizations.of(context)!.next,
              ),
              onPressed: () {
                if (!isLands && !isShops) {
                  if (isCompressing) {
                    Fluttertoast.showToast(
                        msg: "الرجاء الانتظار حتى تنتهي عملية الضغط!");
                    return;
                  }
                  if (!validateData()) return;
                  widget.currentOffer.estateImages = propertyImages!;
                  widget.currentOffer.streetImages = streetPropertyImages;
                  widget.currentOffer.floorPlanImages = floorPlanPropertyImages;
                } else {
                  widget.currentOffer.description = descriptionController.text;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => (isLands || isShops)
                        ? CreatePropertyScreenFinish(
                            currentOffer: widget.currentOffer)
                        : CreatePropertyScreen6(
                            currentOffer: widget.currentOffer),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool validateData() {
    if (!isImagesCountValidate(
      context,
      propertyImages == null ? 0 : propertyImages!.length,
      streetPropertyImages == null ? 0 : streetPropertyImages!.length,
      floorPlanPropertyImages == null ? 0 : floorPlanPropertyImages!.length,
    )) {
      return false;
    }
    return true;
  }
}
