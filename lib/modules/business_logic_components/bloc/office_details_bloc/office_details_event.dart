
abstract class GetOfficesEvents {}

class GetOfficesDetailsStarted extends GetOfficesEvents {
  int? officeId;

  GetOfficesDetailsStarted({required this.officeId});
}

