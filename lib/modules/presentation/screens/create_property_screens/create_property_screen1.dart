import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/estate_offer_type.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'create_property_screen2.dart';

class CreatePropertyScreen1 extends StatefulWidget {
  static const String id = "CreatePropertyScreen1";
  final int officeId ;
  const CreatePropertyScreen1({Key? key ,  required this.officeId}) : super(key: key);

  @override
  _CreatePropertyScreen1State createState() => _CreatePropertyScreen1State();
}

class _CreatePropertyScreen1State extends State<CreatePropertyScreen1> {
  // other:
  late List<EstateType> estateTypes;

  late List<EstateOfferType> offerTypes;

  late Estate _currentOffer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentOffer = Estate(officeId: widget.officeId);
    estateTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    offerTypes =
        BlocProvider.of<EstateOfferTypesBloc>(context).estateOfferTypes!;
    _currentOffer.estateType = estateTypes.first;
    _currentOffer.estateOfferType = offerTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: homeOutlineIconPath,
      headerText: "الخطوة الأولى",
      body: Column(
        children: [
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":نوع العقار",
              textStyle: textStyling(S.s18, W.w6, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe16,
          MyDropdownList(
            elementsList: estateTypes.map((e) => e.name.split('|').first).toList(),
            onSelect: (index) {
              _currentOffer.estateType = estateTypes.elementAt(index);
            },
          ),
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":نوع العرض",
              textStyle: textStyling(S.s18, W.w6, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe16,
          MyDropdownList(
            elementsList: offerTypes.map((e) => e.name).toList(),
            onSelect: (index) {
              _currentOffer.estateOfferType = offerTypes.elementAt(index);
            },
          ),
          const Spacer(),
          MyButton(
            child: ResText(
              "التالي",
              textStyle: textStyling(S.s16, W.w5, C.wh),
            ),
            width: Res.width(240),
            height: Res.height(56),
            color: secondaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CreatePropertyScreen2(currentOffer: _currentOffer),
                ),
              );
            },
          ),
          kHe12,
        ],
      ),
    );
  }
}
