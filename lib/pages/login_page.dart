import 'package:flutter/material.dart';

import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';



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
            onPressed: () { 
              print(emailCtrl.text);
              print(passCtrl.text); 
            },
          ),

          SizedBox( height: 10 )

        ],
      )
    );
  }
}
