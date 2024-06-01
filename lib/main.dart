import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note_gm/views/home_view.dart'; // Corrigido o caminho para o pacote views
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

void main() async {
  // Inicialize o SQFlite FFI
  sqflite_ffi.sqfliteFfiInit();

  // Inicialize os dados de localização
  initializeDateFormatting();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}


// Defina a classe HomeView aqui...
