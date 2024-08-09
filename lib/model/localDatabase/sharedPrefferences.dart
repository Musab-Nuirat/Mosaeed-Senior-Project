import 'package:shared_preferences/shared_preferences.dart';

String loginKey = "isLoggedIn";
String userIDKey = "userIDKey";
String onBoarding="onBoarding";

void setDontNeedOnBoarding() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool(onBoarding, false);
}
Future<bool?> checkIsNeedOnBoarding() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool(onBoarding);
}
dynamic getFromSharedPrefs(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.get(key);
}

void setAsLoggedIn() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool(loginKey, true);
}

void setAsLoggedOut() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool(loginKey, false);
}

Future<bool?> isLoggedIn() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool(loginKey);
}

void saveUserID(String userId) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(userIDKey, userId);
}

Future<String?> getUserID() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString(userIDKey);
}

