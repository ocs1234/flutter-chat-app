import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/socket_service.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        // muestra el token de inmediato porq () hace que se ejecute
        builder: ( context, snapshot ) {
          return Center(
          child: Text('Espere...'),
          );
        },
      ),
   );
  }
   // aqui podemos poner lo que quqeramos, esta pag es solo para saber a donde 
   // redirigiremos nuestro usuario si es que tiene token valid o no

  Future checkLoginState( BuildContext context ) async {
   
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if( autenticado ) {
      // Navigator.pushReplacementNamed(context, 'usuarios');
      socketService.connect();
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: ( _, __, ___ ) => UsuariosPage(),
        transitionDuration: Duration( milliseconds: 0 )
      ));
    } else{
      print('============== no esta funcionando =============');
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: ( _, __, ___ ) => LoginPage(),
        transitionDuration: Duration( milliseconds: 0 )
        )
      );
    }

  }

}