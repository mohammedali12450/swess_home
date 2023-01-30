import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../business_logic_components/bloc/terms_condition_bloc/terms_condition_bloc.dart';
import '../../business_logic_components/bloc/terms_condition_bloc/terms_condition_event.dart';
import '../../business_logic_components/bloc/terms_condition_bloc/terms_condition_state.dart';
import '../../data/repositories/terms_condition_repository.dart';
import '../widgets/wonderful_alert_dialog.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  late TermsConditionBloc _termsConditionBloc;

  @override
  void initState() {
    _termsConditionBloc = TermsConditionBloc(TermsAndConditionsRepository());
    _termsConditionBloc.add(TermsConditionFetchStarted(termsType: "home-terms-use"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<TermsConditionBloc, TermsConditionStates>(
            bloc: _termsConditionBloc,
            builder: (_, propertiesFetchState) {
              if (propertiesFetchState is TermsConditionFetchError) {
                if (propertiesFetchState.isConnectionError) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.no_internet_connection,
                  );
                }
              }
              if (propertiesFetchState is TermsConditionFetchProgress) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                        child: CircularProgressIndicator()));
              }
              if (propertiesFetchState is TermsConditionFetchComplete) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    22.verticalSpace,
                    Text(
                      _termsConditionBloc.termsCondition!.title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    22.verticalSpace,
                    Text(_termsConditionBloc.termsCondition!.body),
                  ],
                );
              } else {

                return Container();
              }
            }),
      ),
    );
  }
}
