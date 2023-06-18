part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {
  const ContactsState();
}

@immutable
class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

@immutable
class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

@immutable
class ContactsEmpty extends ContactsState {
  const ContactsEmpty();
}

@immutable
class ContactsNoPermission extends ContactsState {
  const ContactsNoPermission();
}

@immutable
class ContactsError extends ContactsState {
  const ContactsError();
}

@immutable
class ContactsData extends ContactsState {
  final List<Contact> contacts;
  const ContactsData({
    required this.contacts,
  });
}
