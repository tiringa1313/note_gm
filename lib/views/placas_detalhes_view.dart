import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io';
import '../models/placa_veiculo.dart';

class PlacaDetalhesView extends StatelessWidget {
  final PlacaVeiculo placaVeiculo;

  PlacaDetalhesView({required this.placaVeiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Placa - ${placaVeiculo.placa}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibindo informações da placa, condutor e observação
            Text('Placa: ${placaVeiculo.placa}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Condutor: ${placaVeiculo.condutor}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Observação: ${placaVeiculo.observacao}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Exibe a foto, se houver
            placaVeiculo.fotoPath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(placaVeiculo.fotoPath),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
