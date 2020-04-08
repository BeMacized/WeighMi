import 'package:flutter/material.dart';

class MenuChoice {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuChoice({this.title = '', this.icon, this.onPressed});
}
