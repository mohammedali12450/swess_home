import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/repositories/rating_repository%7B.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class RatingScreen extends StatefulWidget {
  static const String id = "RatingScreen";

  const RatingScreen({Key? key}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController notesController = TextEditingController();
  ChannelCubit selectedRatingCubit = ChannelCubit(-1);
  final RatingBloc _ratingBloc = RatingBloc(RatingRepository());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
              "تقييم التطبيق",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        body: Padding(
          padding: kMediumSymWidth,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                kHe32,
                SizedBox(
                  width: inf,
                  child: ResText(
                    "قم باختيار التقييم",
                    textAlign: TextAlign.center,
                    textStyle: textStyling(S.s18, W.w5, C.bl),
                  ),
                ),
                kHe32,
                BlocBuilder(
                    bloc: selectedRatingCubit,
                    builder: (_, selectedRating) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RatingChoiceWidget(
                            assetPath: sadFacePath,
                            ratingName: "سيئ",
                            onTap: () {
                              selectedRatingCubit.setState(1);
                            },
                            isPressed: (selectedRating == 1),
                          ),
                          kWi16,
                          RatingChoiceWidget(
                            assetPath: normalFacePath,
                            ratingName: "متوسط",
                            onTap: () {
                              selectedRatingCubit.setState(2);
                            },
                            isPressed: (selectedRating == 2),
                          ),
                          kWi16,
                          RatingChoiceWidget(
                            assetPath: happyFacePath,
                            ratingName: "جيد",
                            onTap: () {
                              selectedRatingCubit.setState(3);
                            },
                            isPressed: (selectedRating == 3),
                          ),
                        ],
                      );
                    }),
                kHe32,
                kHe24,
                SizedBox(
                  width: inf,
                  child: ResText(
                    ": ملاحظات واقتراحات ( اختياري )",
                    textStyle: textStyling(S.s18, W.w6, C.bl),
                    textAlign: TextAlign.right,
                  ),
                ),
                kHe16,
                SizedBox(
                  width: inf,
                  height: Res.height(200),
                  child: TextField(
                    style: textStyling(S.s15, W.w5, C.bl),
                    maxLines: 8,
                    maxLength: 250,
                    textDirection: TextDirection.rtl,
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: "أكتب الملاحظات والاقتراحات...",
                      hintStyle: textStyling(S.s15, W.w5, C.hint),
                      hintTextDirection: TextDirection.rtl,
                      border: kOutlinedBorderBlack,
                      focusedBorder: kOutlinedBorderBlack,
                    ),
                  ),
                ),
                kHe24,
                MyButton(
                  child: BlocConsumer<RatingBloc, RatingState>(
                    bloc: _ratingBloc,
                    listener: (_, ratingState) async {

                      if(ratingState is RatingComplete){
                        selectedRatingCubit.setState(-1);
                        notesController.clear() ;
                        // unfocused text field :
                        FocusScope.of(context).unfocus();
                      }

                      if (ratingState is RatingError) {
                        await showWonderfulAlertDialog(context, "خطأ", ratingState.error);
                      }
                      if (ratingState is RatingComplete) {
                        MySnackBar.show(context, "شكرا لكم, تم إرسال التقييم بنجاح");
                      }
                    },
                    builder: (_, ratingState) {
                      if (ratingState is RatingProgress) {
                        return const SpinKitWave(
                          size: 16,
                          color: white,
                        );
                      }
                      return ResText(
                        "إرسال التقييم",
                        textStyle: textStyling(S.s16, W.w5, C.wh).copyWith(
                            color: (ratingState is RatingComplete) ? white.withOpacity(0.48) : white),
                      );
                    },
                  ),
                  width: Res.width(240),
                  height: Res.height(56),
                  color: secondaryColor,
                  onPressed: () {
                    if (_ratingBloc.state is RatingProgress || _ratingBloc.state is RatingComplete) {
                      return;
                    }

                    if (selectedRatingCubit.state == -1) {
                      Fluttertoast.showToast(msg: "يجب تحديد التقييم أولا!");
                      return;
                    }

                    String? token;
                    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
                      token = BlocProvider.of<UserLoginBloc>(context).user!.token!;
                    }
                    _ratingBloc.add(
                      RatingStarted(
                          token: token,
                          rate: selectedRatingCubit.state.toString(),
                          notes: notesController.text),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingChoiceWidget extends StatelessWidget {
  final String assetPath;
  final String ratingName;
  final Function() onTap;
  final bool isPressed;

  const RatingChoiceWidget(
      {Key? key,
      required this.assetPath,
      required this.ratingName,
      required this.onTap,
      required this.isPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: kSmallAllPadding,
        decoration: BoxDecoration(
            color: (isPressed) ? secondaryColor : Colors.transparent,
            border: Border.all(color: black),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            SvgPicture.asset(
              assetPath,
              width: Res.width(80),
              color: (isPressed) ? white : black,
            ),
            kHe12,
            ResText(
              ratingName,
              textStyle: textStyling(S.s14, W.w5, (isPressed) ? C.wh : C.bl),
            ),
          ],
        ),
      ),
    );
  }
}
