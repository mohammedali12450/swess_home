import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../data/models/rent_estate.dart';
import '../../data/repositories/rent_estate_repository.dart';
import '../widgets/immediately_card.dart';

class MyImmediatelyRentScreen extends StatefulWidget {
  static const String id = "MyImmediatelyRentScreen";

  const MyImmediatelyRentScreen({Key? key}) : super(key: key);

  @override
  _MyImmediatelyRentScreenState createState() =>
      _MyImmediatelyRentScreenState();
}

class _MyImmediatelyRentScreenState extends State<MyImmediatelyRentScreen> {
  late RentEstateBloc rentEstateBloc;
  List<RentEstate> rentEstates = [];

  @override
  void initState() {
    super.initState();
    rentEstateBloc = RentEstateBloc(RentEstateRepository());
    _onRefresh();
  }

  Future _onRefresh() async {
    rentEstateBloc.add(
      GetMyRentEstatesFetchStarted(
          token: UserSharedPreferences.getAccessToken()!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.my_estate_immediately,
          ),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            _onRefresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: 1.sw,
              height: 1.sh - 75.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              child: BlocBuilder<RentEstateBloc, RentEstateState>(
                  bloc: rentEstateBloc,
                  builder: (context, rentState) {
                    if (rentState is GetMyRentEstateFetchProgress) {
                      return const NotificationsShimmer();
                    }
                    if (rentState is GetMyRentEstateFetchComplete) {
                      if (rentEstates.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.house_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.12),
                              size: 0.5.sw,
                            ),
                            kHe24,
                            Text(
                              AppLocalizations.of(context)!
                                  .you_have_not_immediately_rent,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.32),
                                  ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: rentEstates.length,
                        itemBuilder: (_, index) {
                          return ImmediatelyCard(
                            rentEstate: rentEstates.elementAt(index),
                            isForCommunicate: false,
                          );
                        },
                      );
                    }
                    return FetchResult(
                        content: AppLocalizations.of(context)!
                            .error_happened_when_executing_operation);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
