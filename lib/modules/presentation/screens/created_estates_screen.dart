import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class CreatedEstatesScreen extends StatefulWidget {
  static const String id = "CreatedEstatesScreen";

  const CreatedEstatesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CreatedEstatesScreenState createState() => _CreatedEstatesScreenState();
}

class _CreatedEstatesScreenState extends State<CreatedEstatesScreen> {
  late CreatedEstatesBloc _createdEstatesBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createdEstatesBloc = CreatedEstatesBloc(EstateRepository());
    _onRefresh();
  }

  _onRefresh() {
    if (BlocProvider.of<UserLoginBloc>(context).user!.token != null) {
      _createdEstatesBloc.add(
        CreatedEstatesFetchStarted(token: BlocProvider.of<UserLoginBloc>(context).user!.token!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Res.height(75),
        backgroundColor: secondaryColor,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: Res.width(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ],
        title: SizedBox(
          width: inf,
          child: ResText(
            "العقارات المسبقة",
            textStyle: textStyling(S.s18, W.w5, C.wh),
            textAlign: TextAlign.right,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: secondaryColor,
        onRefresh: () async {
          _onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: screenWidth,
            height: screenHeight - Res.height(75),
            child: BlocConsumer<CreatedEstatesBloc, CreatedEstatesState>(
              bloc: _createdEstatesBloc,
              listener: (_, createdEstatesFetchState) {
                if (createdEstatesFetchState is CreatedEstatesFetchError) {
                  showWonderfulAlertDialog(context, "خطأ", createdEstatesFetchState.error);
                }
              },
              builder: (_, createdEstatesFetchState) {
                if (createdEstatesFetchState is CreatedEstatesFetchProgress) {
                  return const EstatesShimmer();
                }
                if (createdEstatesFetchState is! CreatedEstatesFetchComplete) {
                  return const FetchResult(content: "حدث خطأ أثناء تنفيذ العملية");
                }

                List<Estate> estates = createdEstatesFetchState.createdEstates;

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: screenWidth / 2,
                          color: secondaryColor.withOpacity(0.64),
                        ),
                        kHe24,
                        ResText(
                          "! لا يوجد لديك عروض عقارية",
                          textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
                            color: black.withOpacity(0.48),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: estates.length,
                  itemBuilder: (_, index) {
                    return EstateCard(
                      estate: estates.elementAt(index),
                      removeBottomBar: true,
                      removeCloseButton: true,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
