import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/estate_immediately_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/screens/my_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/screens/profile_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen_nav_bar.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';

import '../../../core/functions/screen_informations.dart';
import 'chat_screen.dart';
import 'create_order_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  static const String id = "NavigationBarScreen";

  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  final ChannelCubit pageCubit = ChannelCubit(0);
  late bool isArabic;

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
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
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
                  selectedLabelStyle: const TextStyle(fontSize: 12),
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search_outlined),
                      label: AppLocalizations.of(context)!.search,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.bookmark_border_outlined),
                      label: AppLocalizations.of(context)!.saved,
                    ),
                    // BottomNavigationBarItem(
                    //   icon: const Icon(Icons.house_outlined),
                    //   label: AppLocalizations.of(context)!.estate_immediately,
                    // ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home_outlined),
                      label: AppLocalizations.of(context)!.estate_order,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.history),
                      label: AppLocalizations.of(context)!.estate_offers2,
                    ),
                    // BottomNavigationBarItem(
                    //   icon: const Icon(Icons.chat_outlined),
                    //   label: AppLocalizations.of(context)!.chat,
                    // ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      label: AppLocalizations.of(context)!.profile,
                    ),
                  ],
                  currentIndex: pageCubit.state,
                  onTap: (index) {
                    pageCubit.setState(index);
                  },
                ),
              );
            }),
      ),
    );
  }

  Widget callPage(int _selectedBar) {
    switch (_selectedBar) {
      case 0:
        return const HomeScreen();
      // if (homeScreen == null) {
      //   homeScreen = const HomeScreen();
      //   homeScreenState = homeScreen!.createState();
      //   return homeScreen!;
      // } else {
      //   return homeScreenState!.build(context);
      // }
      case 1:
        return const SavedEstatesScreenNavBar();
      case 2:
        return const CreateOrderScreen();
      case 3:
        return const RecentEstateOrdersScreen();
      case 4:
        return const ProfileScreen();
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
