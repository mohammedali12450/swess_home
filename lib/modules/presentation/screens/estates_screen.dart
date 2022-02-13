import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:swesshome/utils/helpers/show_my_snack_bar.dart';

class EstatesScreen extends StatefulWidget {
  static const String id = "EstatesScreen";

  final EstateEvent searchData;

  const EstatesScreen({Key? key, required this.searchData}) : super(key: key);

  @override
  _EstatesScreenState createState() => _EstatesScreenState();
}

class _EstatesScreenState extends State<EstatesScreen> {
  final List<Estate> estates = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          toolbarHeight: Res.height(75),
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: white,
                ),
                onPressed: () {
                  // TODO : Process this state
                },
              ),
              kWi4,
              IconButton(
                icon: const Icon(
                  Icons.public,
                  color: white,
                ),
                onPressed: () {
                  // TODO : Process this state
                },
              ),
              const Spacer(),
              ResText(
                "نتائج البحث",
                textStyle: textStyling(
                  S.s20,
                  W.w5,
                  C.wh,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: white,
                ),
                onPressed: () {
                  Navigator.pop(context) ;
                },
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: Res.width(4)),
          child: BlocProvider<EstateBloc>(
            create: (_) => EstateBloc(
              EstateRepository(),
            )..add(widget.searchData),
            child: BlocConsumer<EstateBloc, EstateState>(
              listener: (_, estateFetchState) {
                if (estateFetchState is EstateFetchComplete) {
                  if (estateFetchState.estates.isEmpty && estates.isNotEmpty) {
                    showMySnackBar(context, "! انتهت النتائج المطابقة لبحثك");
                  }
                }
              },
              builder: (context, estatesFetchState) {
                if (estatesFetchState is EstateFetchNone ||
                    (estatesFetchState is EstateFetchProgress &&
                        estates.isEmpty)) {
                  return const EstatesShimmer();
                } else if (estatesFetchState is EstateFetchComplete) {
                  estates.addAll(estatesFetchState.estates);
                  BlocProvider.of<EstateBloc>(context).isFetching = false;
                }

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: secondaryColor.withOpacity(0.24),
                          size: 120,
                        ),
                        kHe24,
                        ResText(
                          "! عذرا, لا يوجد عقارات مناسبة لبحثك",
                          textStyle: textStyling(S.s18, W.w6, C.bl),
                        ),
                        kHe12,
                        ResText(
                          "قم بتغيير فلتر البحث ثم حاول مجدداً",
                          textStyle: textStyling(S.s14, W.w5, C.bl),
                        ),
                        kHe40,
                        MyButton(
                          color: secondaryColor,
                          width: Res.width(200),
                          child: ResText(
                            "ابحث مجدداً",
                            textStyle: textStyling(S.s18 , W.w6 , C.wh),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  controller: _scrollController
                    ..addListener(
                      () {
                        if (_scrollController.offset ==
                                _scrollController.position.maxScrollExtent &&
                            !BlocProvider.of<EstateBloc>(context).isFetching) {
                          BlocProvider.of<EstateBloc>(context)
                            ..isFetching = true
                            ..add(widget.searchData);
                        }
                      },
                    ),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: estates.length,
                        itemBuilder: (_, index) {
                          return EstateCard(
                            estate: estates.elementAt(index),
                          );
                        },
                      ),
                      if (BlocProvider.of<EstateBloc>(context).isFetching)
                        Container(
                          margin: EdgeInsets.only(
                            top: Res.height(12),
                          ),
                          child: const SpinKitWave(
                            color: secondaryColor,
                            size: 50,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
