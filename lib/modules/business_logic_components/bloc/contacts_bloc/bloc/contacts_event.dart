part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {
  const ContactsEvent();
}

@immutable
class ContactsFetch extends ContactsEvent {
  const ContactsFetch();
}
