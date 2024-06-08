
import 'package:flutter/cupertino.dart';

class Account {
  final String userId;
  final String username;
  final String name;
  final ImageProvider avatar;

  const Account({
    required this.userId, 
    required this.username,
    required this.name,
    required this.avatar, 

  });
}