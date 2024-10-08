import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:permission_handler/permission_handler.dart';

import '../../../../data/models/customer.dart';
import '../../../../data/repositories/contacts_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(const ContactsInitial()) {
    on<ContactsFetch>((event, emit) async {
      emit(const ContactsLoading());

      final permissionStatus = await getContactPermission();

      if (permissionStatus != PermissionStatus.granted) {
        emit(const ContactsNoPermission());
      }

      final contacts = await getContacts();
      List<Customer> customers = [];
      for (int i = 0; i < contacts.length; i++) {
        customers
            .add(Customer.fromContact(contacts.elementAt(i), i.toString()));
      }
      List<bool> isRegisteredList=await ContactsRepository().fetchData(customers);

      emit(
        ContactsData(
          isRegistered: isRegisteredList,
          contacts: contacts.toList(),
        ),
      );
    });
  }

  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<Iterable<Contact>> getContacts() async {
    List<Contact> contacts = await ContactsService.getContacts();

    return contacts.where(
      (contact) => contact.phones?.isNotEmpty ?? false,
    );
  }
}
