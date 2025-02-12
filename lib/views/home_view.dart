import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_gm/views/used_boletins_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boletim_detail_view.dart';
import 'boletim_view.dart';
import '../models/database_helper.dart';
import '../models/boletim.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Boletim> boletins = [];
  List<Boletim> _filteredBoletins = [];
  TextEditingController viaturaController = TextEditingController();
  TextEditingController nomenclaturaController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isViaturaFixed = false;
  bool isNomenclaturaFixed = false;

  @override
  void initState() {
    super.initState();
    _loadBoletins();
    _loadViatura();
  }

  Future<void> _loadBoletins() async {
    boletins = await DatabaseHelper().getBoletins();
    _filteredBoletins = List.from(boletins); // Initialize the filtered list
    print("Número de boletins carregados: ${boletins.length}");
    setState(() {});
  }

  Future<void> _loadViatura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? viatura = prefs.getString('viatura');
    String? nomenclatura = prefs.getString('nomenclatura');
    if (viatura != null) {
      viaturaController.text = viatura;
      nomenclaturaController.text = nomenclatura ?? '';
      setState(() {
        isViaturaFixed = true;
        isNomenclaturaFixed = true;
      });
    }
  }

  Future<void> _saveViatura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('viatura', viaturaController.text);
    await prefs.setString('nomenclatura', nomenclaturaController.text);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
  }

  void _searchBoletins() {
    setState(() {
      if (searchController.text.isEmpty) {
        _filteredBoletins = List.from(boletins);
      } else {
        _filteredBoletins = boletins.where((boletim) {
          return boletim.tituloAtendimento.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ||
              boletim.descricao.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  );
        }).toList();
      }
    });
  }

  void _excluirBoletim(String boletimId) async {
    try {
      // Exclui o boletim do banco de dados
      await DatabaseHelper().deleteBoletim(boletimId);

      // Atualiza a lista de boletins após a exclusão
      _loadBoletins();

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Boletim excluído com sucesso!')),
      );
    } catch (e) {
      // Exibe uma mensagem de erro se a exclusão falhar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o boletim: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletins'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: viaturaController,
                          decoration: InputDecoration(
                            labelText: 'Número da Viatura',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isViaturaFixed
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  isViaturaFixed = !isViaturaFixed;
                                });
                                if (isViaturaFixed) {
                                  _saveViatura();
                                } else {
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.remove('viatura');
                                    prefs.remove('nomenclatura');
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: nomenclaturaController,
                          decoration: InputDecoration(
                            labelText: 'Viatura',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isNomenclaturaFixed
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  isNomenclaturaFixed = !isNomenclaturaFixed;
                                });
                                if (isNomenclaturaFixed) {
                                  _saveViatura();
                                } else {
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.remove('nomenclatura');
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Boletim',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search), // Ícone de lupa
                    ),
                    onChanged: (value) {
                      _searchBoletins();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBoletins.length,
              itemBuilder: (context, index) {
                Boletim boletim = _filteredBoletins[index];
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      title: Text(
                        boletim.tituloAtendimento,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(boletim.data),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoletimDetailView(
                              boletim: boletim,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _excluirBoletim(boletim.id);
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addBoletim',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? viatura = prefs.getString('viatura');
              String? nomenclatura = prefs.getString('nomenclatura');
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoletimView(
                    viatura: viatura ?? "",
                    nomenclatura: nomenclatura ?? "",
                  ),
                ),
              );
              if (result == true) {
                _loadBoletins(); // Recarrega a lista de boletins se um novo boletim foi salvo
              }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
