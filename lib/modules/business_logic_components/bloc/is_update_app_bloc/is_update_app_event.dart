abstract class IsUpdateAppEvent {}

class IsUpdateAppStarted extends IsUpdateAppEvent {
  bool isAndroid;

  String version;

  IsUpdateAppStarted({required this.isAndroid, required this.version});
}
