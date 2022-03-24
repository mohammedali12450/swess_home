import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
    String q1 = "كيف يمكنني البحث عن منزل بمواصفات محددة؟";
    String q1Answer =
        "عند فتح الصفحة الرئيسية يظهر مربع البحث ٬ قم بالضغط عليه و اختيار المنطقة المراد البحث فيها ومن ثم ستظهر فلاتر البحث التي ستساعدك بالعثور على عقارك بشكل سريع عبر البحث البسيط أو المتقدم";
    String q2 = "كيف يمكنني نشر عقار على التطبيق ؟";
    String q2Answer =
        "بعد إنشاء حساب على التطبيق ، قم بالضغط على مربع البحث الخاص بالمكاتب العقارية و اختيار المكتب العقاري الذي تريد النشر عن طريقه، و من ثم قم بتعبئة الخانات بمواصفات عقارك الصحيحة";
    String q3 = "كيف يمكنني إنشاء حساب على التطبيق ؟";
    String q3Answer =
        "قم بكتابة رقم هاتفك و اسمك ، ليصلك كود التفعيل خلال دقائق ، تستطيع من خلال انشاء الحساب الاستفادة من عدة ميزات كإرسال طلب عقاري و نشر عرض و حفظ العقارات المفضلة و غيرها";
    String q4 = "ما هي ميزة 'الطلب العقاري' ومتى ألجأ إليها؟";
    String q4Answer =
        " في حال كنت تبحث عن عقار بمواصفات معينة ولم تعثر عليه من خلال البحث، يمكنك الضغط على ميزة 'الطلبات العقارية' و كتابة مواصفات العقار الذي تبحث عنه، ليصل طلبك إلى كافة المكاتب العقارية المشتركة";
    String q5 = "كيف يمكنني التواصل مع المكتب العقاري؟";
    String q5Answer =
        "يمكنك البحث عن مكتب عقاري محدد عن طريق الضغط   على ميزة انشر عرضك العقاري وكتابة اسم المكتب المراد البحث عنه، كما يمكنك البحث عن المكاتب العقارية المتواجدة في منطقة معينة عن طريق كتابة اسم المنطقة، كما سيظهر رقم المكتب العقاري مع كل عرض خاص به";

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: Res.height(75),
          backgroundColor: AppColors.secondaryColor,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          title: SizedBox(
            width: inf,
            child: ResText(
              "الأسئلة الشائعة",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
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
    return Container(
      margin: EdgeInsets.only(bottom: Res.height(12)),
      child: ExpansionTile(
        backgroundColor: AppColors.thirdColor,
        childrenPadding: kLargeSymWidth,
        iconColor: AppColors.secondaryColor,
        collapsedIconColor: AppColors.secondaryColor,
        title: FAQTextWidgets(
          isTitle: true,
          content: header,
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
    TextStyle textStyle = textStyling(S.s15, W.w4, C.bl);
    if (widget.isTitle) {
      textStyle = textStyling(S.s16, W.w5, C.bl);
    }
    return Text(
      widget.content,
      style: textStyle.copyWith(height: 2),
      textAlign: TextAlign.right,
      maxLines: 50,
    );
  }
}
