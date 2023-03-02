import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';

import '../../business_logic_components/cubits/channel_cubit.dart';

class MyDropdownList extends StatefulWidget {
  final List<dynamic> elementsList;
  final void Function(dynamic index) onSelect;
  final int initElementIndex;
  final Function()? onTap;
  final bool isOnChangeNull;
  final String? selectedItem;
  final FormFieldValidator? validator;

  const MyDropdownList({
    Key? key,
    required this.elementsList,
    required this.onSelect,
    this.initElementIndex = -1,
    this.onTap,
    this.isOnChangeNull = false,
    this.selectedItem,
    this.validator,
  }) : super(key: key);

  @override
  _MyDropdownListState createState() => _MyDropdownListState();
}

class _MyDropdownListState extends State<MyDropdownList> {
  late final ChannelCubit _elementSelectCubit;

  @override
  void initState() {
    super.initState();
    // initializing:
    _elementSelectCubit = ChannelCubit(
      widget.elementsList.elementAt(
          (widget.initElementIndex == -1) ? 0 : widget.initElementIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return BlocBuilder<ChannelCubit, dynamic>(
      bloc: _elementSelectCubit,
      builder: (_, selectedItem) {
        selectedItem is String?;
        selectedItem ??= widget.elementsList.first;
        return DropdownButtonFormField(
          validator: widget.validator,
          decoration: InputDecoration(
              errorStyle: TextStyle(
                height: 0.1.h
              ),
              hintText: widget.selectedItem,
              hintStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 15.sp,
              )),
          isExpanded: true,
          items: widget.elementsList.map(
            (dynamic element) {
              return DropdownMenuItem(
                value: element,
                child: Container(
                  width: 1.sw,
                  margin: EdgeInsets.only(
                    right: Provider.of<LocaleProvider>(context).isArabic()
                        ? 16.w
                        : 0,
                    left: Provider.of<LocaleProvider>(context).isArabic()
                        ? 0
                        : 16.w,
                  ),
                  child: Text(
                    element.toString(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      height: 0.5.h
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (widget.isOnChangeNull)
              ? null
              : (selectedElement) {
                  _elementSelectCubit.setState(selectedElement);
                  widget
                      .onSelect(widget.elementsList.indexOf(selectedElement!));
                },
          onTap: widget.onTap,
        );
      },
    );
  }
}
