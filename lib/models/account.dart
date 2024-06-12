
import 'package:flutter/cupertino.dart';

class Account {
  final String userId;
  final String username;
  final String name;
  final String avatarPath;
  final ImageProvider avatar;

  const Account({
    required this.userId, 
    required this.username,
    required this.name,
    required this.avatar, 
    required this.avatarPath, 

  });
}