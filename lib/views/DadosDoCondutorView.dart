import 'dart:io';

import 'package:flutter/material.dart';

import '../models/database_helper.dart';
import '../models/placa_veiculo.dart';

class DadosDoCondutorView extends StatefulWidget {
  final String placa;

  DadosDoCondutorView({required this.placa});

  @override
  _DadosDoCondutorViewState createState() => _DadosDoCondutorViewState();
}

class _DadosDoCondutorViewState extends State<DadosDoCondutorView> {
  PlacaVeiculo? _placaVeiculo;

  @override
  void initState() {
    super.initState();
    _loadPlacaData();
  }

  Future<void> _loadPlacaData() async {
    try {
      PlacaVeiculo placa = await DatabaseHelper().getPlacaDetails(widget.placa);
      setState(() {
        _placaVeiculo = placa;
      });
    } catch (e) {
      print('Erro ao carregar dados da placa: $e');
      // Aqui você pode mostrar uma mensagem de erro, se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dados do Condutor')),
      body: _placaVeiculo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Placa: ${_placaVeiculo!.placa}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Condutor: ${_placaVeiculo!.condutor}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('CNH: ${_placaVeiculo!.cnh}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('CPF: ${_placaVeiculo!.cpf}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Observação: ${_placaVeiculo!.observacao}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  _placaVeiculo!.fotoPath.isNotEmpty
                      ? Image.file(File(_placaVeiculo!.fotoPath),
                          height: 150, width: 150, fit: BoxFit.cover)
                      : Container(),
                ],
              ),
            ),
    );
  }
}
