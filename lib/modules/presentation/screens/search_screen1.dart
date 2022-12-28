import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/screens/filter_search_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import '../../../constants/assets_paths.dart';
import '../../data/providers/locale_provider.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({Key? key}) : super(key: key);

  @override
  State<SearchScreen1> createState() => _SearchScreen1State();
}

class _SearchScreen1State extends State<SearchScreen1> {
  List<Estate> estateSearch = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: estateSearch.isEmpty ? buildEmptyScreen() : Container()),
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
                  width: 100,
                  alignment: Alignment.center,
                  height: 72.h,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      AppLocalizations.of(context)!.search,
                      style:
                          const TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FilterSearchScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
    );
  }

  Widget buildEmptyScreen() {
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
