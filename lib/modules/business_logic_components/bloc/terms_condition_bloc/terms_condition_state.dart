abstract class TermsConditionStates {}

class TermsConditionFetchNone extends TermsConditionStates {}

class TermsConditionFetchError extends TermsConditionStates {
  final String errorMessage;

  final bool isConnectionError;

  TermsConditionFetchError(
      {required this.errorMessage, this.isConnectionError = false});
}

class TermsConditionFetchProgress extends TermsConditionStates {}

class TermsConditionFetchComplete extends TermsConditionStates {}
