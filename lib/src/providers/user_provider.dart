import 'dart:convert';

import 'package:form_validation/src/share_pref/preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {

  final String _fireBaseKey ='YOUR OWN API KEY';
  final _prefs = new PreferencesUser();

  Future<Map<String, dynamic>> login(String email, String password) async {
    
    final authData = {
     'email': email,
     'password': password,
     'returnSecureToken' : true
   };

    final resp = await http.post(
     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_fireBaseKey',
     body: json.encode(authData)
     );

    Map<String, dynamic> jsonDecodedResp = json.decode(resp.body);

    print(jsonDecodedResp);

    if (jsonDecodedResp.containsKey('idToken')) {
      _prefs.token = jsonDecodedResp['idToken'];
      return {'ok':true, 'token': jsonDecodedResp['idToken']};
    } else {
      return {'ok':false, 'mensaje': jsonDecodedResp['error']['message']};
    }

  }


  Future<Map<String, dynamic>> newUSer(String email, String password ) async{

   final authData = {
     'email': email,
     'password': password,
     'resturnSecureToken' : true
   };

   final resp = await http.post(
     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_fireBaseKey',
     body: json.encode(authData)
     );

     Map<String, dynamic> jsonDecodedResp = json.decode(resp.body);

     print(jsonDecodedResp);

     if (jsonDecodedResp.containsKey('idToken')) {
       _prefs.token = jsonDecodedResp['idToken'];
       return {'ok':true, 'token': jsonDecodedResp['idToken']};
     } else {
       return {'ok':false, 'mensaje': jsonDecodedResp['error']['message']};
     }


 }
  
}