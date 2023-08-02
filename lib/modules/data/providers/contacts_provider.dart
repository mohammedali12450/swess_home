import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';

import '../../../utils/services/network_helper.dart';
import '../models/customer.dart';

class ContactsProvider {
  Future fetchStatusOfContacts(List<Customer> contacts) async {
    NetworkHelper helper = NetworkHelper();
    print(jsonEncode(CustomerList(customers: contacts).toJson()));
    Response response;
    try {
      response = await helper.post(checkExistingcustomers,
          jsonEncode(CustomerList(customers: contacts).toJson()),
          headers: {
            'Accept': 'application/json',
            'Accept-Language': 'ar',
            'Content-Type': 'application/json'
          });
      print(response);
    } catch (_) {
      rethrow;
    }
    return response;
  }
}
