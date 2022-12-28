import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import '../../../constants/application_constants.dart';
import '../../../core/storage/shared_preferences/application_shared_preferences.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import '../../business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/estate_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/estate_card.dart';
import '../widgets/shimmers/estates_shimmer.dart';

late EstateBloc estateBloc;

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late bool isArabic;
  List<Estate> estateNewest = [];
  List<Estate> estateSpacial = [];
  List<Estate> estateMostView = [];


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    estateBloc = EstateBloc(EstateRepository());
    ApplicationSharedPreferences.setWalkThroughPassState(true);
    _onRefresh();
    if (UserSharedPreferences.getAccessToken() != null) {
      sendFcmToken(0);
    }
  }

  _onRefresh() {
    estateBloc.add(NewestEstatesFetchStarted());
    estateBloc.add(MostViewEstatesFetchStarted());
    estateBloc.add(SpacialEstatesFetchStarted());
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.application_name,
        ),
        leading: Builder(
          builder: (context) {
            return Container(
              margin: EdgeInsets.only(
                right: isArabic ? 8.w : 0,
                left: !isArabic ? 8.w : 0,
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () {
          return _onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AdvertisementsEstate(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  AppLocalizations.of(context)!.new_estate + " :",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              buildNewEstate(),
              kHe28,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  AppLocalizations.of(context)!.most_common + " :",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              buildMostViewEstate(),
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
    );
  }

  Widget buildNewEstate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocBuilder<EstateBloc, EstateState>(
        bloc: estateBloc,
        builder: (_, estateState) {
          if (estateState is EstateNewestFetchProgress) {
            return const PropertyShimmer();
          }
          if (estateState is EstateNewestFetchComplete) {
            estateNewest = estateState.estates;
          }
          print("estateNewest : $estateNewest");
          return SizedBox(
            height: 430,
            child: ListView.builder(
              itemCount: estateNewest.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return EstateCard(
                    removeBottomBar: true,
                    estate: estateNewest.elementAt(index),
                    removeCloseButton: true,
                    color: Theme.of(context).colorScheme.background);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildMostViewEstate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BlocBuilder<EstateBloc, EstateState>(
        bloc: estateBloc,
        builder: (_, estateState) {
          if (estateState is EstateMostViewFetchProgress) {
            return const PropertyShimmer();
          }
          if (estateState is EstateMostViewFetchComplete) {
            estateMostView = estateState.estates;
          }
          print("estateMostView : $estateMostView");
          return SizedBox(
            height: 430,
            child: ListView.builder(
              itemCount: estateMostView.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return EstateCard(
                    removeBottomBar: true,
                    estate: estateMostView.elementAt(index),
                    removeCloseButton: true,
                    color: Theme.of(context).colorScheme.background);
              },
            ),
          );
        },
      ),
    );
  }
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

class AdvertisementsEstate extends StatefulWidget {
  const AdvertisementsEstate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AdvertisementsEstateState();
  }
}

class _AdvertisementsEstateState extends State<AdvertisementsEstate> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: getScreenWidth(context),
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              //height: 230,
              autoPlay: true,
              viewportFraction: 1.0,
              //enlargeCenterPage: true,
              // aspectRatio: 1.7,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
