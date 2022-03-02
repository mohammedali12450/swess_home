import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'res_text.dart';

class MyDropdownList extends StatefulWidget {
  final List<dynamic> elementsList;
  final void Function(dynamic index) onSelect;
  final bool? isOnChangeNull;

  const MyDropdownList(
      {Key? key, required this.elementsList, required this.onSelect, this.isOnChangeNull = false})
      : super(key: key);

  @override
  _MyDropdownListState createState() => _MyDropdownListState();
}

class _MyDropdownListState extends State<MyDropdownList> {
  late final ChannelCubit _elementSelectCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializing:
    _elementSelectCubit = ChannelCubit(widget.elementsList.elementAt(0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, dynamic>(
      bloc: _elementSelectCubit,
      builder: (_, selectedItem) {
        return DropdownButton<dynamic>(
          isExpanded: true,
          value: selectedItem,
          items: widget.elementsList.map(
            (dynamic element) {
              return DropdownMenuItem<dynamic>(
                value: element,
                child: Container(
                  width: inf,
                  margin: EdgeInsets.only(
                    right: Res.width(16),
                  ),
                  child: ResText(
                    element.toString(),
                    textStyle: textStyling(S.s18, W.w4, C.bl),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (widget.isOnChangeNull == true)
              ? null
              : (selectedElement) {
                  _elementSelectCubit.setState(selectedElement);
                  widget.onSelect(widget.elementsList.indexOf(selectedElement));
                },
        );
      },
    );
  }
}
