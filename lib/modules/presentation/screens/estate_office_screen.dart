import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_introduction_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/rate_container.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'authentication_screen.dart';

class EstateOfficeScreen extends StatefulWidget {
  final EstateOffice office;

  const EstateOfficeScreen(this.office, {Key? key}) : super(key: key);

  @override
  _EstateOfficeScreenState createState() => _EstateOfficeScreenState();
}

class _EstateOfficeScreenState extends State<EstateOfficeScreen> {
  late ChannelCubit isLikedCubit;
  final EstateBloc _estateBloc = EstateBloc(EstateRepository());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLikedCubit = ChannelCubit(false);
    _estateBloc.add(
      OfficeEstatesFetchStarted(officeId: widget.office.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _estateBloc,
      child: Scaffold(
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          title: SizedBox(
            width: inf,
            child: ResText(
              "تفاصيل المكتب",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(
              left: Res.width(16),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.public,
                color: white,
              ),
              onPressed: () {},
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _estateBloc.add(
              OfficeEstatesFetchStarted(officeId: widget.office.id!),
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                kHe32,
                Hero(
                  tag: widget.office.id.toString(),
                  child: CircleAvatar(
                    radius: Res.width(96),
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                        baseUrl + widget.office.logo!),
                  ),
                ),
                kHe24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: RateContainer(
                        rate: double.parse(widget.office.rating!),
                      ),
                    ),
                    kWi8,
                    ResText(
                      widget.office.name!,
                      textStyle:
                          textStyling(S.s24, W.w6, C.bl).copyWith(height: 1.8),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
                kHe16,
                SizedBox(
                  width: screenWidth,
                  child: ResText(
                    widget.office.location!.getLocationName(),
                    textStyle: textStyling(S.s18, W.w5, C.bl),
                    textAlign: TextAlign.center,
                  ),
                ),
                kHe12,
                SizedBox(
                  width: screenWidth,
                  child: ResText(
                    widget.office.mobile!,
                    textStyle: textStyling(S.s18, W.w5, C.bl),
                    textAlign: TextAlign.center,
                  ),
                ),
                kHe32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      width: Res.width(150),
                      onPressed: () async {
                        if (BlocProvider.of<UserLoginBloc>(context).user ==
                            null) {
                          await showWonderfulAlertDialog(context, "تأكيد",
                              "إن هذه الميزة تتطلب تسجيل الدخول",
                              removeDefaultButton: true,
                              dialogButtons: [
                                MyButton(
                                  child: ResText(
                                    "إلغاء",
                                    textStyle: textStyling(S.s16, W.w5, C.wh)
                                        .copyWith(height: 1.8),
                                  ),
                                  width: Res.width(140),
                                  color: secondaryColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                MyButton(
                                  child: ResText(
                                    "تسجيل الدخول",
                                    textStyle: textStyling(S.s16, W.w5, C.wh)
                                        .copyWith(height: 1.8),
                                  ),
                                  width: Res.width(140),
                                  color: secondaryColor,
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, AuthenticationScreen.id);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                              width: Res.width(400));
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePropertyIntroductionScreen(
                                officeId: widget.office.id!),
                          ),
                        );
                      },
                      color: white,
                      shadow: [lowElevation],
                      border: Border.all(color: secondaryColor),
                      borderRadius: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          ResText(
                            "نشر عقار",
                            textStyle: textStyling(S.s14, W.w5, C.bl),
                          )
                        ],
                      ),
                    ),
                    kWi16,
                    MyButton(
                      width: Res.width(150),
                      onPressed: () {
                        isLikedCubit.setState(!isLikedCubit.state);
                      },
                      color: white,
                      shadow: [lowElevation],
                      border: Border.all(color: secondaryColor),
                      borderRadius: 4,
                      child: BlocBuilder<ChannelCubit, dynamic>(
                        bloc: isLikedCubit,
                        builder: (_, isLiked) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon((isLiked)
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined),
                              kWi12,
                              ResText(
                                (isLiked) ? "تم الإعجاب" : "إعجاب",
                                textStyle: textStyling(S.s14, W.w5, C.bl),
                                textAlign: TextAlign.right,
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
                kHe40,
                Container(
                  height: Res.height(32),
                  width: screenWidth,
                  color: secondaryColor,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: Res.width(8)),
                  child: ResText(
                    ": العروض العقارية",
                    textStyle: textStyling(S.s14, W.w4, C.wh),
                    textAlign: TextAlign.right,
                  ),
                ),
                kHe24,
                BlocBuilder<EstateBloc, EstateState>(
                  bloc: _estateBloc,
                  builder: (_, estateState) {
                    if (estateState is EstateFetchProgress) {
                      return const EstatesShimmer();
                    }
                    if (estateState is! EstateFetchComplete) {
                      return Container();
                    }

                    List<Estate> estates = estateState.estates;

                    return ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: estates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(estate: estates.elementAt(index));
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
