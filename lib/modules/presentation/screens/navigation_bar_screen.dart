import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/estate_immediately_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/screens/my_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/screens/my_estates_orders_screen_nav_bar.dart';
import 'package:swesshome/modules/presentation/screens/profile_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen_nav_bar.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import '../../../core/functions/screen_informations.dart';
import 'chat_screen.dart';
import 'create_order_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';



class NavigationBarScreen extends StatefulWidget {
  static const String id = "NavigationBarScreen";

  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  final ChannelCubit pageCubit = ChannelCubit(0);
  late bool isArabic;

  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  GlobalKey keyBottomNavigation4 = GlobalKey();
  GlobalKey keyBottomNavigation5 = GlobalKey();


  @override
  void initState() {
    super.initState();
    ApplicationSharedPreferences.isFirstLaunchForDefinitionTour().then((result) {
      if(result) {
        createTutorial();
        Future.delayed(Duration.zero, showTutorial);
      }
    });
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: AppColors.lastColor,
      textSkip: "SKIP",
      textStyleSkip: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      paddingFocus: 0,
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "1- ${AppLocalizations.of(context)!.search_definition_tour_1}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "2- ${AppLocalizations.of(context)!.search_definition_tour_2}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.estate_offers_definition_tour,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.saved_definition_tour,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: keyBottomNavigation4,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.estate_order_definition_tour,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation5",
        keyTarget: keyBottomNavigation5,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  AppLocalizations.of(context)!.profile_definition_tour,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }


  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: SizedBox(
          width: getScreenWidth(context) * (75 / 100),
          child: const Drawer(
            child: MyDrawer(),
          ),
        ),
        body: BlocBuilder<ChannelCubit, dynamic>(
          bloc: pageCubit,
          builder: (_, pageNum) {
            return Directionality(textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr, child: callPage(pageNum));
          },
        ),
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(bottom: 20.w),
        //   child: FloatingActionButton(
        //     elevation: 2,
        //     backgroundColor: colors.AppColors.white,
        //     shape: StadiumBorder(
        //         side: BorderSide(color: Colors.yellow.shade700, width: 1)),
        //     onPressed: () {
        //       showBlurScreen(context: context);
        //     },
        //     child: Image.asset(
        //       swessHomeIconPath,
        //       //color: Colors.white,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BlocBuilder<ChannelCubit, dynamic>(
            bloc: pageCubit,
            builder: (_, pageNum) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                child: SizedBox(
                                  key: keyBottomNavigation1,
                                  height: 50,
                                  width: 50,
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: SizedBox(
                                  key: keyBottomNavigation2,
                                  height: 50,
                                  width: 50,
                                ),
                              )),
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                key: keyBottomNavigation3,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Center(
                                child: SizedBox(
                                  key: keyBottomNavigation4,
                                  height: 50,
                                  width: 50,
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: SizedBox(
                                  key: keyBottomNavigation5,
                                  height: 50,
                                  width: 50,
                                ),
                              )),
                        ],
                      ),
                    ),
                    BottomNavigationBar(
                      backgroundColor: isDark ? const Color(0xff26282B) : AppColors.white,
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      unselectedLabelStyle: const TextStyle(fontSize: 12),
                      selectedLabelStyle: const TextStyle(fontSize: 12,),
                      selectedItemColor: AppColors.lastColor,
                      unselectedItemColor: const Color(0xFF818283),
                      items: [
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(searchPath,color: pageCubit.state == 0 ? AppColors.lastColor : const Color(0xFF818283)),
                          label: AppLocalizations.of(context)!.search,
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(orderPath,color: pageCubit.state == 1 ? AppColors.lastColor : const Color(0xFF818283)),
                          label: AppLocalizations.of(context)!.estate_offers2,
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(savedPath,color: pageCubit.state == 2 ? AppColors.lastColor : const Color(0xFF818283)),
                          label: AppLocalizations.of(context)!.saved,
                        ),
                        // BottomNavigationBarItem(
                        //   icon: const Icon(Icons.house_outlined),
                        //   label: AppLocalizations.of(context)!.estate_immediately,
                        // ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(createEstatePath,color: pageCubit.state == 3 ? AppColors.lastColor : const Color(0xFF818283)),
                          label: AppLocalizations.of(context)!.estate_order,
                        ),
                        // BottomNavigationBarItem(
                        //   icon: const Icon(Icons.chat_outlined),
                        //   label: AppLocalizations.of(context)!.chat,
                        // ),
                        BottomNavigationBarItem(
                          icon: Image.asset(profilePath,color: pageCubit.state == 4 ? AppColors.lastColor : const Color(0xFF818283),
                          width: 28,
                          ),
                          label: AppLocalizations.of(context)!.profile,
                        ),
                      ],
                      currentIndex: pageCubit.state,
                      onTap: (index) {
                        pageCubit.setState(index);
                      },
                    ),
                  ],
                )
              );
            }),
      ),
    );
  }

  Widget callPage(int _selectedBar) {
    switch (_selectedBar) {
      case 0:
        return HomeScreen();
      // if (homeScreen == null) {
      //   homeScreen = const HomeScreen();
      //   homeScreenState = homeScreen!.createState();
      //   return homeScreen!;
      // } else {
      //   return homeScreenState!.build(context);
      // }
      case 1:
        return RecentEstateOrdersScreenNavBar();
      case 2:
        return SavedEstatesScreenNavBar();
      case 3:
        return const CreateOrderScreen();
      case 4:
        return ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  // late ChannelCubit selectedLanguageCubit;

  // Widget buildNavigationBar() {
  //   bool isArabic = ApplicationSharedPreferences.getLanguageCode() == "ar";
  //   bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
  //   return BlocBuilder<ChannelCubit, dynamic>(
  //     bloc: ChannelCubit(
  //         Provider.of<LocaleProvider>(context).getLocale().languageCode == "ar"
  //             ? false
  //             : true),
  //     builder: (_, lang) {
  //       return SpinCircleBottomBarHolder(
  //         onPressedCenterButton: () {
  //           showBlurScreen(context: context);
  //         },
  //         bottomNavigationBar: SCBottomBarDetails(
  //           circleColors: [
  //             colors.AppColors.primaryDark,
  //             colors.AppColors.lastColor,
  //             colors.AppColors.primaryColor,
  //           ],
  //           iconTheme: IconThemeData(
  //               color: isDark ? Colors.white : Colors.black45, size: 17),
  //           activeIconTheme: const IconThemeData(
  //               color: colors.AppColors.lastColor, size: 22),
  //           backgroundColor:
  //               !isDark ? Colors.white : colors.AppColors.secondaryDark,
  //           titleStyle: TextStyle(
  //               color: isDark ? colors.AppColors.white : Colors.black45,
  //               fontSize: 13),
  //           activeTitleStyle: Theme.of(context).textTheme.headline5!.copyWith(
  //               fontSize: 13,
  //               fontWeight: FontWeight.w700,
  //               color: colors.AppColors.lastColor),
  //           actionButtonDetails: SCActionButtonDetails(
  //             color: colors.AppColors.white,
  //             icon: Image.asset(
  //               swessHomeIconPath,
  //               //color: Colors.white,
  //             ),
  //             elevation: 2,
  //           ),
  //           bnbHeight: 62,
  //           elevation: 2.0,
  //           items: [
  //             SCBottomBarItem(
  //                 icon: Icons.home_outlined,
  //                 title: lang ? "home" : "الرئيسية",
  //                 onPressed: () {
  //                   pageCubit.setState(0);
  //                 }),
  //             SCBottomBarItem(
  //                 icon: Icons.search,
  //                 title: AppLocalizations.of(context)!.search,
  //                 onPressed: () {
  //                   pageCubit.setState(1);
  //                 }),
  //             SCBottomBarItem(
  //                 icon: Icons.chat_outlined,
  //                 title: AppLocalizations.of(context)!.chat,
  //                 onPressed: () {
  //                   pageCubit.setState(2);
  //                 }),
  //             SCBottomBarItem(
  //                 icon: Icons.person_outline,
  //                 title: AppLocalizations.of(context)!.profile,
  //                 onPressed: () {
  //                   pageCubit.setState(3);
  //                 }),
  //           ],
  //         ),
  //         child: BlocBuilder<ChannelCubit, dynamic>(
  //           bloc: pageCubit,
  //           builder: (_, pageNum) {
  //             return Directionality(
  //                 textDirection:
  //                     isArabic ? TextDirection.rtl : TextDirection.ltr,
  //                 child: callPage(pageNum));
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
