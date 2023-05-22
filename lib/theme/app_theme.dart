

import 'package:flutter/material.dart';

final lightTheme =ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme( centerTitle: true,
    backgroundColor: Color(0xffF2C94C),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    )
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0xffEEEEEE),
    titleTextStyle: TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10),),
    ),
  ),

);