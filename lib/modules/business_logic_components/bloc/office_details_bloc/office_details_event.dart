
abstract class GetOfficesEvents {}

class GetOfficesDetailsStarted extends GetOfficesEvents {
  int? officeId;
  String? token;

  GetOfficesDetailsStarted({required this.officeId,this.token});
}

