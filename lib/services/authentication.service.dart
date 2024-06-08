import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_movie_data_base/models/account.dart';
import '../utils/config.dart'; 


class AuthenticationService {
  final String baseUrl = Config.baseUrl;
  final String apiKey = Config.apiKey;

  Future<Account> login(String username, String password) async {
    try {
      // Paso 1: Crear un token de solicitud
      final tokenResponse = await http.get(
        Uri.parse('$baseUrl/authentication/token/new?api_key=$apiKey'),
      );

      if (tokenResponse.statusCode != 200) {
        throw Exception('Error al obtener el token de solicitud');
      }

      final tokenData = json.decode(tokenResponse.body);
      final requestToken = tokenData['request_token'];

      // Paso 2: Validar el token de solicitud con el nombre de usuario y la contraseña
      final validateResponse = await http.post(
        Uri.parse('$baseUrl/authentication/token/validate_with_login?api_key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'request_token': requestToken,
        }),
      );

      if (validateResponse.statusCode != 200) {
        final errorData = json.decode(validateResponse.body);
        if (errorData.containsKey('status_message')) {
          throw Exception(errorData['status_message']);
        }
        throw Exception('Error al validar el token con el nombre de usuario y la contraseña');
      }

      final validateData = json.decode(validateResponse.body);

      // Paso 3: Crear una sesión con el token de solicitud validado
      final sessionResponse = await http.post(
        Uri.parse('$baseUrl/authentication/session/new?api_key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'request_token': validateData['request_token'],
        }),
      );

      if (sessionResponse.statusCode != 200) {
        throw Exception('Error al crear la sesión');
      }

      final sessionData = json.decode(sessionResponse.body);
      final sessionId = sessionData['session_id'];

      // Paso 4: Obtener la información de la cuenta del usuario
      final accountResponse = await http.get(
        Uri.parse('$baseUrl/account?api_key=$apiKey&session_id=$sessionId'),
      );

      if (accountResponse.statusCode != 200) {
        throw Exception('Error al obtener la cuenta del usuario');
      }

      final accountData= json.decode(accountResponse.body);


      final account = Account(
            userId: accountData['id'].toString(), 
            username: accountData['username'], 
            name: accountData['username'], 
            avatar: getAvatarImage(accountData),
            
          );

      return account;

    } catch (error) {
      rethrow;
    }
  }

   ImageProvider<Object> getAvatarImage(accountData) {
    if (accountData.containsKey('avatar') &&
        accountData['avatar'] != null &&
        accountData['avatar']['tmdb'] != null &&
        accountData['avatar']['tmdb']['avatar_path'] != null) {
      final String avatarPath = accountData['avatar']['tmdb']['avatar_path'];
      return NetworkImage('https://image.tmdb.org/t/p/w500$avatarPath');
    } else {
      return const AssetImage('assets/logo.png');
    }
  }
}
