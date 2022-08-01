// Events

abstract class SearchOfficesEvents {}

class SearchOfficesByNameStarted extends SearchOfficesEvents {
  String name;
  String? token ;

  SearchOfficesByNameStarted({required this.name , required this.token});
}

class SearchOfficesByLocationStarted extends SearchOfficesEvents {
  int locationId;

  SearchOfficesByLocationStarted({required this.locationId});
}

class SearchOfficesCleared extends SearchOfficesEvents {}
