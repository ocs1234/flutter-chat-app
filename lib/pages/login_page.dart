import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:chat/widgets/boton_azul.dart';




class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.969,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Logo( titulo: 'Messenger', ),

                _Form(),

                Labels( ruta: 'register', text1: '¿No tienes cuenta?', text2: 'Crea una ahora!', ),

                SizedBox(height: 30),
                Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ))

              ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50 ),

      child: Column(
        children: <Widget>[

         CustomInput(
           icon: Icons.mail_outline,
           placeHolder: 'Correo',
           keyboardType: TextInputType.emailAddress,
           textController: emailCtrl,
         ),

         CustomInput(
           icon: Icons.lock,
           placeHolder: 'Contraseña',
           textController: passCtrl,
           isPassword: true,
         ),
          
          BotonAzul(
            text: 'ingrese', 
            onPressed: authService.autenticando ? null : () async { 

              FocusScope.of(context).unfocus();
              // para quitar el teclado despues de la accion (focuscope)

              final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
              
              if( loginOk ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else{
                // mostrar alerta
                mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
              }

            },
          ),

          SizedBox( height: 10 )

        ],
      )
    );
  }
}
