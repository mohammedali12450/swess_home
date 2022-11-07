class TermsCondition {
  final int id;
  final String title;
  final String body;

  TermsCondition({required this.id, required this.title, required this.body});

  factory TermsCondition.copy(TermsCondition termsCondition) {
    return TermsCondition(
        id: termsCondition.id,
        title: termsCondition.title,
        body: termsCondition.body);
  }

  factory TermsCondition.init() {
    return TermsCondition(id: -1, title: "default", body: "default");
  }

  factory TermsCondition.fromJson(json) {
    return TermsCondition(
        id: json['id'], title: json['title'], body: json["body"]);
  }
}
