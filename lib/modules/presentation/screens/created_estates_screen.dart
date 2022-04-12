import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(
          AppLocalizations.of(context)!.recent_created_estates,
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: 1.sw,
            height: 1.sh - 75.h,
            child: BlocConsumer<CreatedEstatesBloc, CreatedEstatesState>(
              bloc: _createdEstatesBloc,
              listener: (_, createdEstatesFetchState) {
                if (createdEstatesFetchState is CreatedEstatesFetchError) {
                  showWonderfulAlertDialog(
                      context, AppLocalizations.of(context)!.error, createdEstatesFetchState.error);
                }
              },
              builder: (_, createdEstatesFetchState) {
                if (createdEstatesFetchState is CreatedEstatesFetchProgress) {
                  return const PropertyShimmer();
                }
                if (createdEstatesFetchState is! CreatedEstatesFetchComplete) {
                  return  FetchResult(
                      content:
                          AppLocalizations.of(context)!.error_happened_when_executing_operation);
                }

                List<Estate> estates = createdEstatesFetchState.createdEstates;

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 0.5.sw,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.64),
                        ),
                        kHe24,
                        Text(
                          AppLocalizations.of(context)!.have_not_created_estates,
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
