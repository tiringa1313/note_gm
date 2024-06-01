import 'package:flutter/material.dart';
import 'boletim_view.dart';
import '../models/database_helper.dart';
import '../models/boletim.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Boletim> boletins = [];

  @override
  void initState() {
    super.initState();
    _loadBoletins();
  }

  Future<void> _loadBoletins() async {
    boletins = await DatabaseHelper().getBoletins();
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletins'),
      ),
      body: ListView.builder(
        itemCount: boletins.length,
        itemBuilder: (context, index) {
          Boletim boletim = boletins[index];
          return ListTile(
            title: Text(boletim.tituloAtendimento),
            subtitle: Text(_formatDate(boletim.data)),
            onTap: () {
              // Código para navegar para uma página de detalhes, se necessário
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoletimView()),
          );
          if (result == true) {
            _loadBoletins(); // Recarrega a lista de boletins se um novo boletim foi salvo
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
