import 'package:flutter/material.dart';
import 'package:the_movie_data_base/models/account.dart';

class AccountProvider extends ChangeNotifier {
  final List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }
}
