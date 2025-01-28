import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_gm/views/boletim_fiscalizacao_view.dart';
import 'package:note_gm/views/home_view.dart'; // Import da HomeView

import 'package:flutter/material.dart';
import 'package:note_gm/views/PlacasVisadasView.dart';
import 'home_view.dart'; // Certifique-se que o caminho está correto

class MenuPrincipalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 colunas
          crossAxisSpacing: 10.0, // Espaço horizontal entre os cards
          mainAxisSpacing: 10.0, // Espaço vertical entre os cards
          children: <Widget>[
            _buildCard(context, 'Boletins', Icons.assignment,
                HomeView()), // Direciona para a HomeView
            _buildCard(context, 'Observações', Icons.traffic,
                null), // Placeholder, sem ação por enquanto
            _buildCard(context, 'Placas Visadas', Icons.motorcycle,
                PlacasVisadasView()), // Direciona para Placas Visadas
            _buildCard(context, 'Modelos', Icons.widgets, null), // Placeholder
            _buildCard(
                context,
                'B.A Trânsito',
                FontAwesomeIcons.triangleExclamation,
                BoletimFiscalizacaoView()),
            _buildCard(
                context, 'BOAT', Icons.report, null), // Novo card para BOAT
          ],
        ),
      ),
    );
  }

  // Função para criar cada Card, com navegação
  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget? destination) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (destination != null) {
            // Navega para a página designada
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48),
              SizedBox(height: 16),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
