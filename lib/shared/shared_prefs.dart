import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  setStringPrefs(String key, value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  getStringPrefs(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  setIntPrefs(String key, value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  getIntPrefs(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  checkPrefExists(String key) async{
    final pref = await SharedPreferences.getInstance();
    if(pref.containsKey(key)){
      print('contain key');
      return true;
    }else{
      print('Not contain');
      return false;
    }
  }
}