import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_data_base/models/account.dart';

class AccountProvider extends ChangeNotifier {
  final List<Account> _accounts = [];
  final AssetImage _image = const AssetImage('assets/fondo4.jpg');

  List<Account> get accounts => _accounts;
  bool get isLoggedIn => _accounts.isNotEmpty;
  AssetImage get image => _image;

  AccountProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final username =   prefs.getString('username');
    final name =   prefs.getString('name');
    final avatarPath = prefs.getString('avatarPath');

      if (userId != null && username != null && name != null && avatarPath != null ) {
        _accounts.add(Account(
        userId: userId,
        username: username,
        name: name,
        avatarPath: avatarPath,
        avatar: getAvatarImage(avatarPath)

        ));
      }
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    _accounts.add(account);
    await _saveSession();
    notifyListeners();
  }

  Future<void> removeAccount() async {
    _accounts.clear();
    await _clearSession();
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final account = _accounts.firstOrNull;
    if (account != null) {
      await prefs.setString('userId', account.userId);
      await prefs.setString('username', account.username);
      await prefs.setString('name', account.name);
      await prefs.setString('avatarPath', account.avatarPath);
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('name');
    await prefs.remove('avatar');
  }

  ImageProvider<Object> getAvatarImage(avatarPath) {

      if(avatarPath != "no avatar"){
        return NetworkImage('https://image.tmdb.org/t/p/w500$avatarPath');
    } else {
        return const AssetImage('assets/logo.png');
    }
  }
}
