abstract class ContactUsEvent {}

class ContactUsStarted extends ContactUsEvent {

  final String email;

  final String subject;

  final String message;

  ContactUsStarted({required this.email, required this.subject, required this.message});
}
