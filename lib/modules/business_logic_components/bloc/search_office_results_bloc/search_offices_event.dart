// Events

abstract class SearchOfficesEvents {}

class SearchOfficesByNameStarted extends SearchOfficesEvents {
  String name;
  String? token ;

  SearchOfficesByNameStarted({required this.name , required this.token});
}

class SearchOfficesByLocationStarted extends SearchOfficesEvents {
  int locationId;
  String? token ;

  SearchOfficesByLocationStarted({required this.locationId , required this.token});
}

class SearchOfficesCleared extends SearchOfficesEvents {}
