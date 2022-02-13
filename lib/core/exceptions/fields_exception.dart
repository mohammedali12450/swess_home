class FieldsException implements Exception{
  dynamic jsonErrorFields ;
  FieldsException({required this.jsonErrorFields});
}