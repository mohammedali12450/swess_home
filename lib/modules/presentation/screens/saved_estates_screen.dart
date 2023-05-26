import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../widgets/estate_card.dart';
import '../widgets/estate_horizon_card.dart';
import '../widgets/res_text.dart';

class SavedEstatesScreen extends StatefulWidget {
  static const String id = "SavedEstatesScreen";

  const SavedEstatesScreen({Key? key}) : super(key: key);

  @override
  _SavedEstatesScreenState createState() => _SavedEstatesScreenState();
}

class _SavedEstatesScreenState extends State<SavedEstatesScreen> {
  late SavedEstatesBloc _savedEstatesBloc;
  List<Estate> estates = [];

  @override
  void initState() {
    super.initState();
    _savedEstatesBloc = SavedEstatesBloc(EstateRepository());
    if (UserSharedPreferences.getAccessToken() != null) {
      _savedEstatesBloc.add(
        SavedEstatesFetchStarted(
            token: UserSharedPreferences.getAccessToken()!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SizedBox(
          width: getScreenWidth(context) * (75 / 100),
          child: const Drawer(
            child: MyDrawer(),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.saved_estates,
          ),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            if (UserSharedPreferences.getAccessToken() != null) {
              _savedEstatesBloc.add(
                SavedEstatesFetchStarted(
                    token: UserSharedPreferences.getAccessToken()!),
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: 1.sw,
              height: 1.sh - 75.h,
              padding: kMediumSymHeight,
              child: BlocConsumer<SavedEstatesBloc, SavedEstatesState>(
                bloc: _savedEstatesBloc,
                listener: (_, savedEstatesState) async {
                  if (savedEstatesState is SavedEstatesFetchError) {
                    var error = savedEstatesState.isConnectionError
                        ? AppLocalizations.of(context)!.no_internet_connection
                        : savedEstatesState.error;
                    await showWonderfulAlertDialog(
                        context, AppLocalizations.of(context)!.error, error);
                  }
                },
                builder: (BuildContext context, savedEstatesState) {
                  if (savedEstatesState is SavedEstatesFetchNone) {
                    return FetchResult(
                        content: AppLocalizations.of(context)!
                            .have_not_saved_estates);
                  }

                  if (savedEstatesState is SavedEstatesFetchProgress) {
                    return const PropertyShimmer();
                  }
                  if (savedEstatesState is! SavedEstatesFetchComplete) {
                    return FetchResult(
                        content: AppLocalizations.of(context)!
                            .error_happened_when_executing_operation);
                  }

                  estates = savedEstatesState.savedEstates;

                  if (estates.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 0.5.sw,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.64),
                          ),
                          kHe24,
                          Text(
                            AppLocalizations.of(context)!
                                .have_not_saved_estates,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      kHe12,
                      buildSavedList(),
                      kHe44,
                      Padding(
                        padding: kTinyAllPadding,
                        child: Container(
                          alignment: Alignment.center,
                          height: 60.h,
                          width: 1.sw,
                          decoration: BoxDecoration(
                            borderRadius: lowBorderRadius,
                            border:
                                Border.all(color: AppColors.yellowDarkColor),
                          ),
                          child: ResText(
                            AppLocalizations.of(context)!.nearby,
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      buildSavedList(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSavedList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: estates.length,
      itemBuilder: (_, index) {
        return EstateHorizonCard(
          estate: estates.elementAt(index),
          closeButton: false,
        );
      },
    );
  }
}
