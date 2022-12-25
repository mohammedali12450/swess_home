import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/providers/locale_provider.dart';
import 'craete_estate_immediately_screen.dart';

class EstateImmediatelyScreen extends StatefulWidget {
  const EstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<EstateImmediatelyScreen> createState() =>
      _EstateImmediatelyScreenState();
}

class _EstateImmediatelyScreenState extends State<EstateImmediatelyScreen> {
  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //expandedHeight: 150,
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(AppLocalizations.of(context)!.estate_immediately),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              title: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        padding: EdgeInsets.only(
                            right: !isArabic ? 12 : 0, left: isArabic ? 12 : 0),
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt_outlined),
                      )),
                  Expanded(
                    flex: 8,
                    child: Container(
                      // width: double.infinity,
                      height: 40,
                      color: Colors.white,
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 4),
                              hintText:
                                  AppLocalizations.of(context)!.estate_search,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      height: 1.5),
                              prefixIcon: const Icon(Icons.search)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 250.0,
            delegate: SliverChildBuilderDelegate((builder, index) {
              return buildEstateCard();
            }, childCount: 30),
          ),
        ],
      ),
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
                    // border color
                    color: AppColors.yellowColor,
                    // border thickness
                    width: 2,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 5, 5, 15),
                  width: 100,
                  alignment: Alignment.bottomCenter,
                  height: 72.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          AppLocalizations.of(context)!.create,
                          style:
                              const TextStyle(color: AppColors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateEstateImmediatelyScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEstateCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Date ",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppColors.lastColor,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.address + " : "),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        Text(AppLocalizations.of(context)!.estate_type + " : "),
                  ),
                  Expanded(
                    child:
                        Text(AppLocalizations.of(context)!.rental_term + " : "),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        AppLocalizations.of(context)!.estate_space + " : "),
                  ),
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.floor + " : "),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.room + " : "),
                  ),
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.salon + " : "),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.bathroom + " : "),
                  ),
                  Expanded(
                    child:
                        Text(AppLocalizations.of(context)!.furnished + " : "),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.estate_price + " : "),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
