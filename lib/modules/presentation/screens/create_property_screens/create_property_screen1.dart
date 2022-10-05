import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_screen2.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';

import '../../../../constants/assets_paths.dart';
import '../../../data/models/estate_offer_type.dart';

class CreatePropertyScreen1 extends StatefulWidget {
  static const String id = "CreatePropertyScreen1";
  final int officeId;

  const CreatePropertyScreen1({Key? key, required this.officeId})
      : super(key: key);

  @override
  _CreatePropertyScreen1State createState() => _CreatePropertyScreen1State();
}

class _CreatePropertyScreen1State extends State<CreatePropertyScreen1> {
  // other:
  late List<EstateType> estateTypes;

  late List<EstateOfferType> offerTypes;

  late Estate _currentOffer;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentOffer = Estate.init();
    _currentOffer.officeId = widget.officeId;
    estateTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    offerTypes =
        BlocProvider.of<EstateOfferTypesBloc>(context).estateOfferTypes!;
    _currentOffer.estateType = estateTypes.first;
    _currentOffer.estateOfferType = offerTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return CreatePropertyTemplate(
      headerIconPath: homeOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_1,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.estate_type + " :",
              ),
            ),
            16.verticalSpace,
            MyDropdownList(
              elementsList: estateTypes
                  .map((e) => e.getName(isArabic).split('|').first)
                  .toList(),
              onSelect: (index) {
                _currentOffer.estateType = estateTypes.elementAt(index);
              },
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
              selectedItem: AppLocalizations.of(context)!.please_select,
            ),
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.offer_type + " :",
              ),
            ),
            16.verticalSpace,
            MyDropdownList(
              elementsList: offerTypes.map((e) => e.getName(isArabic)).toList(),
              onSelect: (index) {
                _currentOffer.estateOfferType = offerTypes.elementAt(index);
              },
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
              selectedItem: AppLocalizations.of(context)!.please_select,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
              child: Text(
                AppLocalizations.of(context)!.next,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CreatePropertyScreen2(currentOffer: _currentOffer),
                    ),
                  );
                }
              },
            ),
            12.verticalSpace,
          ],
        ),
      ),
    );
  }
}
