import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:swesshome/constants/colors.dart' as colors;
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/chat_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_screen1.dart';
import 'package:swesshome/modules/presentation/screens/settings_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';

import '../widgets/blur_create_estate.dart';
import 'create_message_screen.dart';

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
        drawer: const Drawer(
          child: MyDrawer(),
        ),
        body: Directionality(
            textDirection: TextDirection.ltr, child: buildNavigationBar()),
      ),
    );
  }

  Widget callPage(int _selectedBar) {
    switch (_selectedBar) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen1();
      //return const FilterSearchScreen();
      // return SearchScreen(
      //   searchData: SearchData(estateOfferTypeId: sellOfferTypeNumber),
      // );
      case 2:
        return const CreateMessageScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget buildNavigationBar() {
    bool isArabic = ApplicationSharedPreferences.getLanguageCode() == "ar";
    return SpinCircleBottomBarHolder(
      onPressedCenterButton: () {
        showBlurScreen(context: context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const CreateEstateScreen(),
        //   ),
        // );
      },
      bottomNavigationBar: SCBottomBarDetails(
        circleColors: [
          colors.AppColors.primaryDark,
          colors.AppColors.lastColor,
          colors.AppColors.primaryColor,
        ],
        iconTheme: const IconThemeData(color: Colors.black45, size: 17),
        activeIconTheme:
            const IconThemeData(color: colors.AppColors.lastColor, size: 22),
        backgroundColor: Colors.white,
        titleStyle: const TextStyle(color: Colors.black45, fontSize: 13),
        activeTitleStyle: Theme.of(context).textTheme.headline5!.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.AppColors.lastColor),
        actionButtonDetails: SCActionButtonDetails(
          color: colors.AppColors.lastColor,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 2,
        ),
        bnbHeight: 62,
        elevation: 2.0,
        items: [
          SCBottomBarItem(
              icon: Icons.home_outlined,
              title: "Home",
              onPressed: () {
                pageCubit.setState(0);
              }),
          SCBottomBarItem(
              icon: Icons.search,
              title: "Search",
              onPressed: () {
                pageCubit.setState(1);
              }),
          SCBottomBarItem(
              icon: Icons.chat_outlined,
              title: "Chat",
              onPressed: () {
                pageCubit.setState(2);
              }),
          SCBottomBarItem(
              icon: Icons.person_outline,
              title: "Profile",
              onPressed: () {
                pageCubit.setState(3);
              }),
        ],
        circleItems: [],
        // circleItems: [
        //   SCItem(icon: const Icon(Icons.add), onPressed: () {}),
        //   //SCItem(icon: const Icon(Icons.print), onPressed: () {}),
        //   SCItem(icon: const Icon(Icons.map), onPressed: () {}),
        // ],
      ),
      child: BlocBuilder<ChannelCubit, dynamic>(
        bloc: pageCubit,
        builder: (_, pageNum) {
          return Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: callPage(pageNum));
        },
      ),
    );
  }
}
