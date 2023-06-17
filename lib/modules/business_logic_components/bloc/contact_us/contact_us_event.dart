abstract class ContactUsEvent {}

class ContactUsStarted extends ContactUsEvent {

  final String email;

  final String title;

  final String message;

  ContactUsStarted({required this.email, required this.title, required this.message});
}
