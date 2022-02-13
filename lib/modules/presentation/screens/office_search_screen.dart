import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/repositories/estate_offices_repository.dart';
import 'package:swesshome/modules/presentation/screens/estate_office_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_location_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_office_card.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/offices_list_shimmer.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class OfficeSearchScreen extends StatefulWidget {
  static const String id = 'OfficeSearchScreen';

  const OfficeSearchScreen({Key? key}) : super(key: key);

  @override
  _OfficeSearchScreenState createState() => _OfficeSearchScreenState();
}

class _OfficeSearchScreenState extends State<OfficeSearchScreen> {
  // Blocs and Cubits :
  ChannelCubit searchTypeCubit = ChannelCubit(OfficeSearchType.name);
  SearchOfficesBloc searchOfficesBloc = SearchOfficesBloc(
    EstateOfficesRepository(),
  );

  // Controllers :
  TextEditingController textFieldController = TextEditingController();

  // Others :

  late List<Location> locations;
  LocationViewer? selectedLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locations = BlocProvider.of<LocationsBloc>(context).locations ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Row(
            children: [
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                builder: (_, searchType) {
                  return InkWell(
                    onTap: () {
                      textFieldController.clear();
                      searchTypeCubit.setState(
                          (searchType == OfficeSearchType.name)
                              ? OfficeSearchType.area
                              : OfficeSearchType.name);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Res.width(8),
                        vertical: Res.height(8),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        border: Border.all(color: white),
                      ),
                      child: ResText(
                        (searchType == OfficeSearchType.name)
                            ? "بحث بالاسم"
                            : "بحث بالمنطقة",
                        textStyle: textStyling(S.s14, W.w4, C.wh),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              ResText(
                "البحث عن مكاتب عقارية",
                textStyle: textStyling(S.s18, W.w6, C.wh),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
            )
          ],
          bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(
                bottom: Res.height(16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Res.width(16),
              ),
              child: BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                builder: (_, searchType) {
                  return TextField(
                    readOnly: (searchType == OfficeSearchType.area),
                    controller: textFieldController,
                    onTap: () async {
                      if (searchType == OfficeSearchType.area) {
                        selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchLocationScreen(),
                          ),
                        ) as LocationViewer;
                        if (selectedLocation != null) {
                          searchOfficesBloc.add(
                            SearchOfficesByLocationStarted(
                                locationId: selectedLocation!.id),
                          );
                          textFieldController.text =
                              selectedLocation!.getLocationName();
                          // unfocused text field :
                          FocusScope.of(context).unfocus();
                        }
                        return;
                      }
                      if (textFieldController.text.isEmpty &&
                          searchType == OfficeSearchType.name) {
                        searchOfficesBloc.add(
                          SearchOfficesByNameStarted(name: ""),
                        );
                      }
                    },
                    onChanged: (newValue) {
                      if (searchType == OfficeSearchType.name) {
                        searchOfficesBloc.add(
                          SearchOfficesByNameStarted(name: newValue),
                        );
                      }
                    },
                    style: textStyling(S.s14, W.w5, C.wh),
                    textDirection: TextDirection.rtl,
                    cursorColor: white,
                    decoration: InputDecoration(
                      hintText: (searchType == OfficeSearchType.name)
                          ? "أدخل اسم المكتب العقاري"
                          : "أدخل اسم المنطقة",
                      hintStyle: textStyling(S.s14, W.w4, C.whHint).copyWith(),
                      hintTextDirection: TextDirection.rtl,
                      border: kUnderlinedBorderGrey,
                      focusedBorder: kUnderlinedBorderGrey,
                      enabledBorder: kUnderlinedBorderGrey,
                    ),
                  );
                },
              ),
            ),
            preferredSize: Size.fromHeight(
              Res.height(80),
            ),
          ),
        ),
        body: Container(
          padding: kMediumSymHeight,
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: searchTypeCubit,
            builder: (_, searchType) {
              if (searchType == OfficeSearchType.area &&
                  selectedLocation == null) {
                return Container();
              }
              if (searchType == OfficeSearchType.name) {
                searchOfficesBloc.add(SearchOfficesByNameStarted(name: ""));
              }
              return buildResultsList();
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder buildResultsList() {
    return BlocBuilder<SearchOfficesBloc, SearchOfficesStates>(
      bloc: searchOfficesBloc,
      builder: (_, searchResultsState) {
        if (searchResultsState is SearchOfficesFetchProgress) {
          return const OfficesListShimmer();
        }
        if (searchResultsState is! SearchOfficesFetchComplete) {
          return Container();
        }
        List<EstateOffice> results = searchResultsState.results;

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  documentOutlineIconPath,
                  color: black.withOpacity(0.32),
                  width: screenWidth / 2,
                ),
                kHe32,
                ResText(
                  "! لا يوجد نتائج مطابقة لبحثك",
                  textStyle: textStyling(S.s24, W.w5, C.hint).copyWith(
                    color: black.withOpacity(0.32),
                  ),
                )
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (searchTypeCubit.state == OfficeSearchType.area) ...[
                SizedBox(
                  width: inf,
                  child: ResText(
                    ": المكاتب الموجودة في هذه المنطقة",
                    textStyle: textStyling(S.s16, W.w5, C.bl),
                    textAlign: TextAlign.right,
                  ),
                ),
                kHe24,
              ],
              ListView.separated(

                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return EstateOfficeCard(
                      office: results.elementAt(index),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_,__,___) => EstateOfficeScreen(
                              results.elementAt(index),
                            ),
                            transitionDuration: const Duration(seconds: 1)
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                  itemCount: results.length),
            ],
          ),
        );
      },
    );
  }
}
