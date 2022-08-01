import 'package:shared_preferences/shared_preferences.dart';
import 'package:swesshome/modules/data/models/otp_model.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/models/user_model.dart';

class DataStore {

  static const String accessTokenKey = "access_token";
  static final DataStore _singletonBloc = new DataStore._internal();

  late UserOtpModel _userModel = UserOtpModel();

  UserOtpModel get user => _userModel;

  OtpRequestValueModel _otpRequestValue = OtpRequestValueModel();


  factory DataStore() {
    return _singletonBloc;
  }

  DataStore._internal() {

    getUser().then((onVal) {
      _userModel = onVal;
    });

  }

  Future<bool> setUser(UserOtpModel value,String access) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userModel = value;
    return prefs.setString(accessTokenKey,access);
  }

  Future<UserOtpModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var x = prefs.getString(accessTokenKey) ?? '';
    var u = x != '' ? userOtpModelFromJson(x) : UserOtpModel(data: UserItem());
    //print("xxxxx" + x);
    return u;
  }

  Future<bool> setLastOtpRequestValue(OtpRequestValueModel value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _otpRequestValue = value;
    return prefs.setString('otpRequestValue', otpRequestValueToJson(value));
  }

  Future<OtpRequestValueModel> getLastOtpRequestValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var x = prefs.getString('otpRequestValue') ?? '';
    var u = x != '' ? otpRequestValueFromJson(x) : OtpRequestValueModel(requestedTime: DateTime.now().subtract(Duration(minutes: 1)));
    //print("xxxxx" + x);
    return u;
  }
}

final dataStore = DataStore();
