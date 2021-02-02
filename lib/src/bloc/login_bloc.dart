import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:form_validation/src/bloc/validator.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc with Validator{

// Forma de emitir datos de un StreamController de dart. Streams
//  final _emailController     = StreamController<String>.broadcast();
//  final _passwordController  = StreamController<String>.broadcast();

// Forma de emitir datos usando rxdart. Observables
 final _emailController     = BehaviorSubject<String>();
 final _passwordController  = BehaviorSubject<String>();

 //Recuperar los datos del Stream (Observable)
 Stream<String> get emailStream => _emailController.stream.transform(validatorEmail);
 Stream<String> get passwordStream  => _passwordController.stream.transform(validatorPassword);

// validar dos datos y si son validos los dos retorna un true.
 Stream<bool> get formValidStream => 
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true );

 //Insertar valores al Stream
 Function(String) get changeEmail => _emailController.sink.add;
 Function(String) get changePassword => _passwordController.sink.add;

 // Obterner el ultimo valor insertado a los streams
 String get email => _emailController.value;
 String get password => _passwordController.value;


 dispose(){
   _emailController?.close(); // si existe lo cierra.
   _passwordController?.close();

 }


}