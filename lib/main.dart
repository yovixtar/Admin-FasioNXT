import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasioNXT Admin',
      theme: ThemeData(
        fontFamily: 'Lato',
        useMaterial3: true,
      ),
      home: LayoutMenu(),
    );
  }
}
