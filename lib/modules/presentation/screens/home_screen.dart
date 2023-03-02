import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/screen_informations.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/last_visited_estates_bloc/last_visited_estates_bloc.dart';
import '../../business_logic_components/bloc/last_visited_estates_bloc/last_visited_estates_state.dart';
import '../../data/models/estate.dart';
import '../../data/repositories/last_visited_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/estate_card.dart';
import '../widgets/shimmers/estates_shimmer.dart';
import 'filter_search_screen.dart';
import 'office_search_screen.dart';

late LastVisitedEstatesBloc lastVisitedEstatesBloc;

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Estate> estateSearch = [];

  @override
  void initState() {
    super.initState();
    lastVisitedEstatesBloc = LastVisitedEstatesBloc(LastVisitedRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: UserSharedPreferences.getAccessToken() == null
              ? buildEmptyScreen(context)
              : buildEstateList(context)),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: GestureDetector(
              child: Card(
                color: AppColors.primaryColor,
                elevation: 4,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: AppColors.yellowColor,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 100.w,
                  alignment: Alignment.center,
                  height: 72.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      AppLocalizations.of(context)!.search,
                      style: TextStyle(color: AppColors.white, fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: lowBorderRadius,
                      ),
                      child: Padding(
                        padding: kTinyAllPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            15.verticalSpace,
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FilterSearchScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.home_work_outlined),
                                    kWi16,
                                    Text(
                                      AppLocalizations.of(context)!
                                          .estate_search,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                )),
                            const Divider(
                              indent: 20,
                              thickness: 0.1,
                              endIndent: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const OfficeSearchScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.house_outlined),
                                    kWi16,
                                    Text(
                                      AppLocalizations.of(context)!
                                          .search_for_estate_agent,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      drawer: SizedBox(
        width: getScreenWidth(context) * (75 / 100),
        child: const Drawer(
          child: MyDrawer(),
        ),
      ),
    );
  }

  Widget buildEstateList(context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: kTinyAllPadding,
                  child: Container(
                    alignment: Alignment.center,
                    height: 70.h,
                    //width: getScreenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: lowBorderRadius,
                      border: Border.all(color: AppColors.yellowDarkColor),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.location,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ), Expanded(
                child: Padding(
                  padding: kTinyAllPadding,
                  child: Container(
                    alignment: Alignment.center,
                    height: 70.h,
                    //width: getScreenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: lowBorderRadius,
                      border: Border.all(color: AppColors.yellowDarkColor),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.estate_type,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: kTinyAllPadding,
                  child: Container(
                    alignment: Alignment.center,
                    height: 70.h,
                    //width: getScreenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: lowBorderRadius,
                      border: Border.all(color: AppColors.yellowDarkColor),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.by_price,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 70.h),
          child: BlocBuilder<LastVisitedEstatesBloc, LastVisitedEstatesState>(
              bloc: lastVisitedEstatesBloc,
              builder: (_, estateState) {
                if (estateState is LastVisitedEstatesFetchComplete) {
                  estateSearch = estateState.lastVisitedEstates;
                }
                if (estateState is LastVisitedEstatesFetchProgress) {
                  return const PropertyShimmer();
                }
                if (estateSearch.isEmpty) {
                  return buildEmptyScreen(context);
                }
                return Stack(
                  children: [
                    kHe24,
                    ListView.builder(
                      itemBuilder: (_, index) {
                        return EstateCard(
                          estate: estateSearch.elementAt(index),
                          removeCloseButton: true,
                          color: Theme.of(context).colorScheme.background,
                        );
                      },
                      itemCount: estateSearch.length,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget buildEmptyScreen(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            documentOutlineIconPath,
            width: 0.5.sw,
            height: 0.5.sw,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.42),
          ),
          48.verticalSpace,
          Text(
            AppLocalizations.of(context)!.have_not_recent_search,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
