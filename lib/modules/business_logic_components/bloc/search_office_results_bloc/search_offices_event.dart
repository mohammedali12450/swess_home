// Events

abstract class SearchOfficesEvents {}

class SearchOfficesByNameStarted extends SearchOfficesEvents {
  String name;

  SearchOfficesByNameStarted({required this.name});
}

class SearchOfficesByLocationStarted extends SearchOfficesEvents {
  int locationId;

  SearchOfficesByLocationStarted({required this.locationId});
}

class SearchOfficesCleared extends SearchOfficesEvents {}
