import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CandidatesScreen extends StatefulWidget {
  static const String id = "CandidatesScreen";

  final List<Estate>? estates;

  const CandidatesScreen({Key? key, required this.estates}) : super(key: key);

  @override
  _CandidatesScreenState createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.candidate_estates,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: (widget.estates == null || widget.estates!.isEmpty)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 0.5.sw,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.64),
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!
                          .no_candidates_for_this_order,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.estates!.length,
                itemBuilder: (_, index) {
                  return EstateCard(
                    estate: widget.estates!.elementAt(index),
                    removeCloseButton: true,
                  );
                },
              ),
      ),
    );
  }
}
