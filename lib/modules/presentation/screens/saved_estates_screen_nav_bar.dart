import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/notifications_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/navigation_bar_screen.dart';
import 'package:swesshome/modules/presentation/screens/notifications_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/icone_badge.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../widgets/estate_horizon_card.dart';
import '../widgets/res_text.dart';

class SavedEstatesScreenNavBar extends StatefulWidget {
  static const String id = "SavedEstatesScreen";

  const SavedEstatesScreenNavBar({Key? key}) : super(key: key);

  @override
  _SavedEstatesScreenNavBarState createState() => _SavedEstatesScreenNavBarState();
}

class _SavedEstatesScreenNavBarState extends State<SavedEstatesScreenNavBar> {
  late SavedEstatesBloc _savedEstatesBloc;
  List<Estate> estates = [];
  late bool isArabic;
  bool? profile;

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
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return SafeArea(
      child: Scaffold(
        drawer: SizedBox(
          width: getScreenWidth(context) * (75 / 100),
          child: const Drawer(
            child: MyDrawer(),
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.saved_estates,
            style: const TextStyle(color: AppColors.black),
          ),
          actions: [
            InkWell(
              child: BlocBuilder<NotificationsCubit, int>(
                builder: (_, notificationsCount) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: isArabic ? 12.w : 0, right: isArabic ? 0 : 12.w),
                    child: IconBadge(
                      icon: const Icon(
                        Icons.notifications_outlined,
                      ),
                      itemCount: notificationsCount,
                      right: 0,
                      top: 5.h,
                      hideZero: true,
                    ),
                  );
                },
              ),
              onTap: () async {
                if (UserSharedPreferences.getAccessToken() == null) {
                  await showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.confirmation,
                      AppLocalizations.of(context)!.this_features_require_login,
                      removeDefaultButton: true,
                      dialogButtons: [
                        ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.sign_in,
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, AuthenticationScreen.id);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                      width: 400.w);
                  return;
                }
                Navigator.pushNamed(context, NotificationScreen.id);
              },
            ),
          ],
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
                            size: 0.2.sw,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                          kHe24,
                          Text(
                            AppLocalizations.of(context)!
                                .have_not_saved_estates,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          kHe24,
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(180.w, 50.h),
                                maximumSize: Size(200.w, 50.h),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.search,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const NavigationBarScreen()));

                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // kHe12,
                        buildSavedList(),
                        kHe20,
                        Padding(
                          padding: kTinyAllPadding,
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.h,
                            width: 1.sw,
                            decoration: const BoxDecoration(
                                borderRadius: lowBorderRadius,
                                // border: Border.all(color: AppColors.primaryColor),
                                color: AppColors.primaryColor
                            ),
                            child: ResText(
                              AppLocalizations.of(context)!.nearby,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.w700,color: Colors.white),
                            ),
                          ),
                        ),
                        buildSavedList(),
                        kHe50,
                      ],
                    ),
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
