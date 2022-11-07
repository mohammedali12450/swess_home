abstract class TermsConditionEvents {}

class TermsConditionFetchStarted extends TermsConditionEvents {
  final String termsType;

  TermsConditionFetchStarted({required this.termsType});
}
