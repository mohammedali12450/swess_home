import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_screen_finish.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';

class CreatePropertyScreen6 extends StatefulWidget {
  static const String id = "CreatePropertyScreen6";

  final Estate currentOffer;

  const CreatePropertyScreen6({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreen6State createState() => _CreatePropertyScreen6State();
}

class _CreatePropertyScreen6State extends State<CreatePropertyScreen6> {
  TextEditingController descriptionController = TextEditingController();
  ChannelCubit textDirectionCubit = ChannelCubit(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: documentOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_6,
      body: Column(
        children: [
          SizedBox(
            width: 1.sw,
            child: Text(AppLocalizations.of(context)!.estate_description +
                " ( ${AppLocalizations.of(context)!.optional} ) :"),
          ),
          16.verticalSpace,
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
                  controller: descriptionController,
                  maxLines: 8,
                  maxLength: 600,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.estate_description_hint,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.48),
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
          64.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
            child: Text(AppLocalizations.of(context)!.create_estate),
            onPressed: () {
              widget.currentOffer.description = descriptionController.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePropertyScreenFinish(currentOffer: widget.currentOffer),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
