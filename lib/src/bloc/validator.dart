import 'dart:async';

class Validator {


  // el StreamTransformer<Entrada, Salida> tiene informacion de entrada e 
  // informacion de salida la cual se espeficica que tipo es.
  final validatorEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if (regExp.hasMatch(email)) {

        sink.add(email);
        
      } else {
        
        sink.addError('no es un email correcto');

      }
    },
  );



  // el StreamTransformer<Entrada, Salida> tiene informacion de entrada e 
  // informacion de salida la cual se espeficica que tipo es.
  final validatorPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('La contraseña es menor a 6');
      }
    },
  );
  
}