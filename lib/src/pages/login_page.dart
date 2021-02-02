import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/login_bloc.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/providers/user_provider.dart';
import 'package:form_validation/src/utils/utils.dart';



class LoginPage extends StatelessWidget {

  final userProvider = UserProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          _createBackground(context),
          _loginForm(context)
        ],
      )
    );
  }

  Widget _loginForm( BuildContext context ) {

    final bloc = Provider.of(context);

    final sizeScreen = MediaQuery.of(context).size;


    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 210.0
            )
          ),

          Container(
            width: sizeScreen.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createEmail(bloc),
                SizedBox(height: 30.0),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createBotton(bloc)
                
              ],
            ),
          ),
          
          FlatButton( 
            child: Text('crear cuenta'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'register'),
          ),

          SizedBox( height: 100.0),
        ],
      ),
    );
  }
  
  Widget _createEmail( LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                    labelText: 'Correo electronico',
                    hintText: 'ejemplo@gmail.com',
                    counterText: snapshot.data,
                    errorText: snapshot.error
                  ),
                  onChanged: (value) => bloc.changeEmail(value)
                ),
              );
      },
    );

  }

  Widget _createPassword( LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.deepPurple),
                    labelText: 'Contraseña',
                    counterText: snapshot.data,
                    errorText: snapshot.error
                  ),
                   onChanged: (value) => bloc.changePassword(value)
                ),
              );
      },
    );

  }

  Widget _createBotton( LoginBloc bloc ) {

    // formValidStream
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          child: RaisedButton(
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                   child: Text('ingresar'),
                 ) ,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(5.0)
                 ),
                 elevation: 10.0,
                 color: Color.fromRGBO(62, 133, 90, 1.0),
                 textColor: Colors.white,
                 onPressed:(snapshot.hasData) ? () => _login(context, bloc): null
               ),
        );
      },
    );

  }

  _login(BuildContext context, LoginBloc bloc ) async{
    // print('==========');
    // print('email:${bloc.email}');
    // print('password:${bloc.password}');
    // print('==========');

    Map info = await userProvider.login(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlert(context, info['mensaje']);
    }

    
  }
 
  Widget _createBackground( BuildContext context) {

    final sizeScreen = MediaQuery.of(context).size;

    final backgroundColorBlue = Container(
      height: sizeScreen.height*0.4, // el alto es igual al 40% de la pantalla
      width: double.infinity, // el ancho de toda la pantalla
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(53, 120, 113, 1.0),
            Color.fromRGBO(63, 110, 92, 1.0),
          ]
        )
      ) ,
    );

    final circle = Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    final avatar = Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_pin_circle, color:Colors.white, size: 100.0),
          SizedBox(height: 10.0, width: double.infinity),
          Text('Alfred Contreras', style: TextStyle(color: Colors.white, fontSize: 25.0),)
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        backgroundColorBlue,
        Positioned(child: circle, left: 30.0, top: 90.0),
        Positioned(child: circle, left: -30.0, top: -40.0),
        Positioned(child: circle, bottom: -50.0, right: -10.0),
        avatar
        
      ],
    );
  }
}