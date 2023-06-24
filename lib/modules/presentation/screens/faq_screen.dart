import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';

import '../../data/providers/locale_provider.dart';
import '../widgets/res_text.dart';

class FAQScreen extends StatefulWidget {
  static const String id = "FAQScreen";

  const FAQScreen({Key? key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<bool> isOpened = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    String q1 = AppLocalizations.of(context)!.faq_1_title;
    String q1Answer = AppLocalizations.of(context)!.faq_1_content;
    String q2 = AppLocalizations.of(context)!.faq_2_title;
    String q2Answer = AppLocalizations.of(context)!.faq_2_content;
    String q3 = AppLocalizations.of(context)!.faq_3_title;
    String q3Answer = AppLocalizations.of(context)!.faq_3_content;
    String q4 = AppLocalizations.of(context)!.faq_4_title;
    String q4Answer = AppLocalizations.of(context)!.faq_4_content;
    String q5 = AppLocalizations.of(context)!.faq_5_title;
    String q5Answer = AppLocalizations.of(context)!.faq_5_content;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.faq,
          ),
        ),
        body: Padding(
          padding: kMediumSymWidth,
          child: ListView(
            shrinkWrap: true,
            children: [
              buildExpansionTile(q1, q1Answer),
              buildExpansionTile(q2, q2Answer),
              buildExpansionTile(q3, q3Answer),
              buildExpansionTile(q4, q4Answer),
              buildExpansionTile(q5, q5Answer),
            ],
          ),
        ),
      ),
    );
  }

  Container buildExpansionTile(String header, String body) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);


    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ExpansionTile(
        backgroundColor: isDark ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
        childrenPadding: kLargeSymWidth,
        iconColor: isDark ? AppColors.white :  Theme.of(context).colorScheme.primary,
        collapsedIconColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: EdgeInsets.only(left: !isArabic ? 8.w : 0, right: isArabic ? 8.w : 0),
          child: FAQTextWidgets(
            isTitle: true,
            content: header,
          ),
        ),
        children: [
          FAQTextWidgets(
            isTitle: false,
            content: body,
          )
        ],
        initiallyExpanded: false,
      ),
    );
  }
}

class FAQTextWidgets extends StatefulWidget {
  final bool isTitle;
  final String content;

  const FAQTextWidgets({Key? key, required this.isTitle, required this.content}) : super(key: key);

  @override
  State<FAQTextWidgets> createState() => _FAQTextWidgetsState();
}

class _FAQTextWidgetsState extends State<FAQTextWidgets> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2!;
    if (widget.isTitle) {
      textStyle = Theme.of(context).textTheme.subtitle1! ;
    }
    return Text(
      widget.content,
      style: textStyle.copyWith(height: 2),
      maxLines: 50,
    );
  }
}
