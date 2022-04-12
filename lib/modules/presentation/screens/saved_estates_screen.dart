import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedEstatesScreen extends StatefulWidget {
  static const String id = "SavedEstatesScreen";

  const SavedEstatesScreen({Key? key}) : super(key: key);

  @override
  _SavedEstatesScreenState createState() => _SavedEstatesScreenState();
}

class _SavedEstatesScreenState extends State<SavedEstatesScreen> {
  late SavedEstatesBloc _savedEstatesBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _savedEstatesBloc = SavedEstatesBloc(EstateRepository());
    if (BlocProvider.of<UserLoginBloc>(context).user!.token != null) {
      _savedEstatesBloc.add(
        SavedEstatesFetchStarted(token: BlocProvider.of<UserLoginBloc>(context).user!.token!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.saved_estates ,
          ),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            if (BlocProvider.of<UserLoginBloc>(context).user!.token != null) {
              _savedEstatesBloc.add(
                SavedEstatesFetchStarted(
                    token: BlocProvider.of<UserLoginBloc>(context).user!.token!),
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: 1.sw,
              height: 1.sh - 75.h,
              padding: kMediumSymHeight,
              child: BlocConsumer<SavedEstatesBloc, SavedEstatesState>(
                bloc: _savedEstatesBloc,
                listener: (_, savedEstatesState) {
                  if (savedEstatesState is SavedEstatesFetchError) {
                    showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, savedEstatesState.error);
                  }
                },
                builder: (BuildContext context, savedEstatesState) {
                  if (savedEstatesState is SavedEstatesFetchProgress) {
                    return const PropertyShimmer();
                  }
                  if (savedEstatesState is! SavedEstatesFetchComplete) {
                    return  FetchResult(content: AppLocalizations.of(context)!.error_happened_when_executing_operation);
                  }

                  List<Estate> estates = savedEstatesState.savedEstates;

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
                            AppLocalizations.of(context)!.have_not_saved_estates,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: estates.length,
                    itemBuilder: (_, index) {
                      return EstateCard(
                        estate: estates.elementAt(index),
                        removeCloseButton: true,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
