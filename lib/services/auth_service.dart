
import 'dart:convert';

import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/enviroment.dart';
import 'package:chat/models/login_response.dart';



class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando( bool valor ) {
    this._autenticando = valor;
    notifyListeners();
  } 

  // Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token    = await _storage.read(key: 'token');
    return token;
  } 

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  } 

  Future<bool> login( String email, String password ) async{
    
    this.autenticando = true;

    final data = {
      'email'   : email,
      'password': password
    };

    final resp = await http.post('${ Environment.apiUrl }/login/', 
     body: jsonEncode(data),
     headers: {
       'Content-Type': 'application/json'
     }
    );

    this.autenticando = false;
    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      
      await this._guardarToken(loginResponse.token);

      return true;
    } else{
      return false;
    }
  }

  Future register( String nombre , String email, String password ) async {

    this.autenticando = true;

    final data = {
      'nombre'  : nombre,
      'email'   : email,
      'password': password
    };

    final resp = await http.post('${ Environment.apiUrl }/login/new',
     body: jsonEncode(data),
     headers: {
       'Content-Type': 'application/json'
     }
    );

    this.autenticando = false;

    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;     
    } else {
      final respBody = jsonDecode(resp.body);
      // Mapea la respusta con el paquete dart:convert
      return respBody['msg'];
      // Con esto regreso un valor booleano si lo hace correcto y si lo hace mal String
    }

  }

  Future<bool> isLoggedIn() async {
   
    final token = await this._storage.read(key: 'token');

     final resp = await http.get('${ Environment.apiUrl }/login/renew',
     headers: {
       'Content-Type': 'application/json',
       'x-token': token
     }
    );

    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      
      await this._guardarToken(loginResponse.token);

      return true;     
    } else {
      this.logout();
      return false;
    }

  }

  Future _guardarToken( String token ) async {
   return await _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    await _storage.delete(key: 'token');
  }

}