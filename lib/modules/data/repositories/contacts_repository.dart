import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:phone_number/phone_number.dart';

import '../../../core/exceptions/unknown_exception.dart';
import '../models/customer.dart';
import '../providers/contacts_provider.dart';

class ContactsRepository {
  ContactsProvider contactsProvider = ContactsProvider();
  Future<List<bool>> fetchData(List<Customer> contacts) async {
    for(Customer contact in contacts){
      for(int i=0;i<contact.phoneNumbers.length;i++) {
        contact.phoneNumbers[i]=await convertToInternational(contact.phoneNumbers[i]);
      }
    }


    Response response = await contactsProvider.fetchStatusOfContacts(contacts);

    if (response.statusCode != 200) {
      throw UnknownException();
    }
    List<dynamic> jsonList  = jsonDecode(response.data);
    List<bool> isRegisterList = jsonList.cast<bool>();
    return isRegisterList;
  }
}

Future<String> convertToInternational(String localNumber) async {
  PhoneNumber phoneNumber = await PhoneNumberUtil().parse(localNumber,regionCode: "SY");

  return phoneNumber.e164;
}
