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
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    var borderRadiusEnglish = const BorderRadius.only(
        topRight: Radius.circular(32), bottomRight: Radius.circular(32));
    var borderRadiusArabic = const BorderRadius.only(
        topLeft: Radius.circular(32), bottomLeft: Radius.circular(32));
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ListTile(
            leading: const Icon(Icons.saved_search),
            title: Text(AppLocalizations.of(context)!.new_search),
            selected: true,
            shape: RoundedRectangleBorder(
                borderRadius:
                    isArabic ? borderRadiusArabic : borderRadiusEnglish),
            selectedTileColor: AppColors.lastColor.withOpacity(0.5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FilterSearchScreen(),
                ),
              );
            },
          ),
          Center(
              child: estateSearch.isEmpty ? buildEmptyScreen() : Container()),
        ],
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
