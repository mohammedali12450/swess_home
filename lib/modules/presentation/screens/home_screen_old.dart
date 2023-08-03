import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_spacial_bloc/estate_spacial_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import '../../../constants/application_constants.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_newest_bloc/estate_newest_bloc.dart';
import '../../business_logic_components/bloc/estate_newest_bloc/estate_newest_event.dart';
import '../../business_logic_components/bloc/estate_newest_bloc/estate_newest_state.dart';
import '../../business_logic_components/bloc/estate_spacial_bloc/estate_spacial_event.dart';
import '../../business_logic_components/bloc/estate_spacial_bloc/estate_spacial_state.dart';
import '../../business_logic_components/bloc/estate_view_bloc/estate_view_bloc.dart';
import '../../business_logic_components/bloc/estate_view_bloc/estate_view_event.dart';
import '../../business_logic_components/bloc/estate_view_bloc/estate_view_state.dart';
import '../../business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import '../../business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home_estate_card.dart';
import '../widgets/res_text.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/shimmers/home_card_shimmer.dart';
import 'estate_details_screen.dart';

//late EstateBloc estateBloc;
late EstateViewBloc estateViewBloc;
late EstateNewestBloc estateNewestBloc;
late EstateSpacialBloc estateSpacialBloc;

class HomeScreen1 extends StatefulWidget {
  static const String id = "HomeScreenOld";

  const HomeScreen1({Key? key}) : super(key: key);

  @override
  State<HomeScreen1> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen1> {
  late bool isArabic;
  late bool isDark;
  List<Estate> estateNewest = [];
  List<Estate> estateMostView = [];

  @override
  void initState() {
    super.initState();
    estateNewestBloc = EstateNewestBloc(EstateRepository());
    estateViewBloc = EstateViewBloc(EstateRepository());
    estateSpacialBloc = EstateSpacialBloc(EstateRepository());
    //estateBloc = EstateBloc(EstateRepository());

    _onRefresh();
    if (UserSharedPreferences.getAccessToken() != null) {
      sendFcmToken(0);
    }
  }

  _onRefresh() async {
    estateNewestBloc.add(NewestEstatesFetchStarted());
    estateViewBloc.add(MostViewEstatesFetchStarted());
    estateSpacialBloc.add(SpacialEstatesFetchStarted());
  }

  Future sendFcmToken(int attempt) async {
    if (attempt == 5) return;
    if (firebaseToken == null) {
      await Future.delayed(const Duration(seconds: 3));
      sendFcmToken(attempt + 1);
    }
    BlocProvider.of<FcmBloc>(context).add(
      SendFcmTokenProcessStarted(
          userToken: UserSharedPreferences.getAccessToken()!),
    );
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.application_name,
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () {
          return _onRefresh();
        },
        child: ListView(
          children: [
            const AdvertisementsEstate(),
            Padding(
              padding: kMediumSymWidth,
              child: ResText(
                AppLocalizations.of(context)!.new_estate + " :",
                textStyle: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            buildNewEstate(),
            kHe16,
            Padding(
              padding: kMediumSymWidth,
              child: ResText(
                AppLocalizations.of(context)!.most_common + " :",
                textStyle: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            buildMostViewEstate(),
            kHe16,
          ],
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

  Widget buildNewEstate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: BlocBuilder<EstateNewestBloc, EstateNewestState>(
        bloc: estateNewestBloc,
        builder: (_, estateState) {
          if (estateState is EstateNewestFetchProgress) {
            estateNewest.clear();
            return const HomeCardShimmer();
          }
          if (estateState is EstateNewestFetchComplete) {
            if (estateNewest.isEmpty) {
              estateNewest = estateState.estates;
            }
          }
          return SizedBox(
            height: !isDark ? 475.h : 485.h,
            child: ListView.builder(
              itemCount: estateNewest.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.only(left: 18.w, right: 3.w, bottom: 20.h),
                  child: HomeEstateCard(estate: estateNewest.elementAt(index)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildMostViewEstate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: BlocBuilder<EstateViewBloc, EstateViewState>(
        bloc: estateViewBloc,
        builder: (_, estateState) {
          if (estateState is EstateMostViewFetchProgress) {
            estateMostView.clear();
            return const HomeCardShimmer();
          }
          if (estateState is EstateMostViewFetchComplete) {
            if (estateMostView.isEmpty) {
              estateMostView = estateState.estates;
            }
          }
          return SizedBox(
            height: !isDark ? 475.h : 485.h,
            child: ListView.builder(
              itemCount: estateMostView.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.only(left: 18.w, right: 3.w, bottom: 20.h),
                  child:
                      HomeEstateCard(estate: estateMostView.elementAt(index)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

List<SpecialEstate> imgList = [];
List<Widget> imageSliders = [];

class AdvertisementsEstate extends StatefulWidget {
  const AdvertisementsEstate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AdvertisementsEstateState();
  }
}

class _AdvertisementsEstateState extends State<AdvertisementsEstate> {
  ChannelCubit currentCubit = ChannelCubit(0);
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return BlocBuilder<EstateSpacialBloc, EstateSpacialState>(
      bloc: estateSpacialBloc,
      builder: (_, spacialState) {
        if (spacialState is EstateSpacialFetchProgress) {
          imgList.clear();
          return ShimmerWidget.rectangular(
            baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
            highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
            height: 300.h,
          );
        }
        if (spacialState is EstateSpacialFetchComplete) {
          imgList = spacialState.estates;
          imageSliders = imgList
              .map((item) => InkWell(
                    child: Container(
                      margin: kTinyAllPadding,
                      child: ClipRRect(
                          borderRadius: smallBorderRadius,
                          child: CachedNetworkImage(
                              imageUrl: item.imageUrl!,
                              fit: BoxFit.cover,
                              width: 1000.w)),
                    ),
                    onTap: () async {
                      EstateRepository estateRepository = EstateRepository();
                      Estate estate =
                          await estateRepository.getEstate(item.estateId!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EstateDetailsScreen(
                            estate: estate,
                          ),
                        ),
                      );
                    },
                  ))
              .toList();
        }
        return BlocBuilder<ChannelCubit, dynamic>(
          bloc: currentCubit,
          builder: (_, current) {
            return Column(
              children: [
                SizedBox(
                  width: getScreenWidth(context),
                  child: CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        //enlargeCenterPage: true,
                        // aspectRatio: 1.7,
                        onPageChanged: (index, _) {
                          currentCubit.setState(index);
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(currentCubit.state == entry.key
                                        ? 0.9
                                        : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
