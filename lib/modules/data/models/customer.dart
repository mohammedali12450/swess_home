import 'package:contacts_service/contacts_service.dart';

class Customer {
  final String id;
  final String name;
  List<String> phoneNumbers;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumbers,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phoneNumbers: List<String>.from(json['phone_numbers']),
    );
  }
  factory Customer.fromContact(Contact contact, String id) {
    return Customer(
      id: id,
      name: contact.displayName ?? "user",
      phoneNumbers:
          contact.phones!.map((number) => number.value ?? '').toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_numbers'] = this.phoneNumbers;
    return data;
  }
}

class CustomerList {
  final List<Customer> customers;

  CustomerList({required this.customers});

  factory CustomerList.fromJson(Map<String, dynamic> json) {
    final List<Customer> customers = List<Customer>.from(
        json['customers'].map((customer) => Customer.fromJson(customer)));
    return CustomerList(customers: customers);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customers'] =
        this.customers.map((customer) => customer.toJson()).toList();
    return data;
  }
}
