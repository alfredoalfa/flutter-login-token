import 'package:shared_preferences/shared_preferences.dart';


class PreferencesUser {

  static final PreferencesUser _instancia = new PreferencesUser._internal();

  factory PreferencesUser() {
    return _instancia;
  }

  SharedPreferences _prefs;

  PreferencesUser._internal();

  initPrefs() async {
   this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }
  

  // GET y SET de la última página
  get lastPage {
    return _prefs.getString('lastPage') ?? 'login';
  }

  set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }


}