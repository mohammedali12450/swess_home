import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

bool isImagesCountValidate(
  BuildContext context,
  int estateImagesCount,
  int streetImagesCount,
  int floorPlanImagesCount,
) {
  SystemVariables _systemVariables = BlocProvider.of<SystemVariablesBloc>(context).systemVariables!;

  int minimumEstateImagesCount = _systemVariables.minimumCountOfEstateImages;
  String maximumEstateImagesCount = _systemVariables.maximumCountOfEstateImages;
  String maximumCountStreetImages = _systemVariables.maximumCountOfStreetImages;
  String maximumCountFloorPlanImages = _systemVariables.maximumCountOfFloorPlanImages;

  String estateWord = AppLocalizations.of(context)!.estate;
  String estateStreetWord = AppLocalizations.of(context)!.estate_street;
  String estateFloorPlanWord = AppLocalizations.of(context)!.estate_floor_plan;
  String moreWord = AppLocalizations.of(context)!.more;
  String lessWord = AppLocalizations.of(context)!.less;

  if (estateImagesCount < minimumEstateImagesCount) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!
          .no_more_less_than_x_images(minimumEstateImagesCount.toString(), estateWord, lessWord),
    );
    return false;
  }

  if (estateImagesCount > int.parse(_systemVariables.maximumCountOfEstateImages)) {
    showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.error,
      AppLocalizations.of(context)!
          .no_more_less_than_x_images(maximumEstateImagesCount, estateWord, moreWord),
    );
    return false;
  }

  if (streetImagesCount > int.parse(_systemVariables.maximumCountOfStreetImages)) {
    showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.error,
      AppLocalizations.of(context)!
          .no_more_less_than_x_images(maximumCountStreetImages, estateStreetWord, moreWord),
    );
    return false;
  }

  if (floorPlanImagesCount > int.parse(_systemVariables.maximumCountOfFloorPlanImages)) {
    showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.error,
      AppLocalizations.of(context)!
          .no_more_less_than_x_images(maximumCountFloorPlanImages, estateFloorPlanWord, moreWord),
    );
    return false;
  }

  return true;
}
