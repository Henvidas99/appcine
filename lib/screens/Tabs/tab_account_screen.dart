import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountService {
  static const String _keyAccountData = 'accountData';

  static Future<Map<String, dynamic>> getAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    final accountDataString = prefs.getString(_keyAccountData);
    if (accountDataString != null) {
      return json.decode(accountDataString);
    } else {
      return {}; // Retorna un mapa vacío si no hay datos almacenados
    }
  }
}

class TabAccountScreen extends StatefulWidget {
  const TabAccountScreen({super.key});

  @override
  _TabAccountScreenState createState() => _TabAccountScreenState();
}

class _TabAccountScreenState extends State<TabAccountScreen> {
  Map<String, dynamic> _accountData = {};

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    final accountData = await AccountService.getAccountData();
    setState(() {
      _accountData = accountData;
    });
  }

    ImageProvider<Object>? _getAvatarImage() {
    if (_accountData.containsKey('avatar') &&
        _accountData['avatar'] != null &&
        _accountData['avatar']['tmdb'] != null &&
        _accountData['avatar']['tmdb']['avatar_path'] != null) {
      final String avatarPath = _accountData['avatar']['tmdb']['avatar_path'];
      return NetworkImage('https://image.tmdb.org/t/p/w500$avatarPath');
    } else {
      return AssetImage('assets/logo.png');
    }
  }

 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondo1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _getAvatarImage(), // Cambia por tu imagen
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'ID: ${_accountData['id'] ?? ''}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Nombre de usuario: ${_accountData['username'] ?? ''}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Nombre: ${_accountData['name'] ?? ''}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 179, 94, 94),
                  ),
                  child: const TabBar(
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Color.fromARGB(255, 213, 192, 192),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.favorite, color: Colors.red,),
                        text: 'Favoritos',
                      ),
                      Tab(
                        icon: Icon(Icons.playlist_add, color: Color.fromARGB(255, 19, 110, 185)),
                        text: 'Watch list',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // Color de fondo del contenido
                    ),
                    child: const TabBarView(
                      children: [
                        Center(
                          child: Text('Contenido de Favoritos'),
                        ),
                        Center(
                          child: Text('Contenido de Lista de Reproducción'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
