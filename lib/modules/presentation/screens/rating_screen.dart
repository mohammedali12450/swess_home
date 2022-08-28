import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/repositories/rating_repository%7B.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  ChannelCubit textDirectionCubit = ChannelCubit(null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.rate_us,
          ),
        ),
        body: Padding(
          padding: kMediumSymWidth,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                kHe32,
                Text(
                  AppLocalizations.of(context)!.select_rating,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
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
                            ratingName: AppLocalizations.of(context)!.bad,
                            onTap: () {
                              selectedRatingCubit.setState(1);
                            },
                            isPressed: (selectedRating == 1),
                          ),
                          kWi16,
                          RatingChoiceWidget(
                            assetPath: normalFacePath,
                            ratingName: AppLocalizations.of(context)!.normal,
                            onTap: () {
                              selectedRatingCubit.setState(2);
                            },
                            isPressed: (selectedRating == 2),
                          ),
                          kWi16,
                          RatingChoiceWidget(
                            assetPath: happyFacePath,
                            ratingName: AppLocalizations.of(context)!.good,
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
                  child: Text(
                    AppLocalizations.of(context)!.notes +
                        " ( ${AppLocalizations.of(context)!.optional} ) :",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                kHe16,
                SizedBox(
                  width: 1.sw,
                  height: 200.h,
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: textDirectionCubit,
                    builder: (_, text) {
                      return TextField(
                        textDirection: (text == null)
                            ? null
                            : intl.Bidi.detectRtlDirectionality(text)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        controller: notesController,
                        maxLines: 8,
                        maxLength: 600,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.enter_rating_notes,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.48),
                                width: 0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          textDirectionCubit.setState(value);
                        },
                      );
                    },
                  ),
                ),
                kHe24,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(220.w, 64.h)),
                  child: BlocConsumer<RatingBloc, RatingState>(
                    bloc: _ratingBloc,
                    listener: (_, ratingState) async {
                      if (ratingState is RatingComplete) {
                        selectedRatingCubit.setState(-1);
                        notesController.clear();
                        // unfocused text field :
                        FocusScope.of(context).unfocus();
                      }

                      if (ratingState is RatingError) {
                        var error = ratingState.isConnectionError
                            ? AppLocalizations.of(context)!
                                .no_internet_connection
                            : ratingState.error;
                        await showWonderfulAlertDialog(context,
                            AppLocalizations.of(context)!.error, error);
                      }
                      if (ratingState is RatingComplete) {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!
                                .after_rate_message,
                            toastLength: Toast.LENGTH_LONG);
                        Navigator.pop(context);
                      }
                    },
                    builder: (_, ratingState) {
                      if (ratingState is RatingProgress) {
                        return SpinKitWave(
                          size: 24.w,
                          color: Theme.of(context).colorScheme.background,
                        );
                      }
                      return Text(
                        AppLocalizations.of(context)!.send_rate,
                      );
                    },
                  ),
                  onPressed: () {
                    if (_ratingBloc.state is RatingProgress ||
                        _ratingBloc.state is RatingComplete) {
                      return;
                    }
                    if (selectedRatingCubit.state == -1) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!
                              .you_must_select_rate_first);
                      return;
                    }

                    String? token;
                    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
                      token =
                          BlocProvider.of<UserLoginBloc>(context).user!.token!;
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
            color: (isPressed)
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            border:
                Border.all(color: Theme.of(context).colorScheme.onBackground),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            SvgPicture.asset(
              assetPath,
              width: 80.w,
              color: (isPressed)
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.onBackground,
            ),
            kHe12,
            Text(
              ratingName,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: isPressed
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}
