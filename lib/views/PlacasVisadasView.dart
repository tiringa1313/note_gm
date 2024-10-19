import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_gm/models/database_helper.dart';

class PlacasVisadasView extends StatefulWidget {
  @override
  _PlacasVisadasViewState createState() => _PlacasVisadasViewState();
}

class _PlacasVisadasViewState extends State<PlacasVisadasView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placaController = TextEditingController();
  List<String> _placas = []; // Lista para armazenar as placas
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Instância do DatabaseHelper

  @override
  void initState() {
    super.initState();
    _fetchPlacas(); // Busca placas ao iniciar a view
  }

  Future<void> _fetchPlacas() async {
    List<String> placas = await _dbHelper.getPlacas();
    setState(() {
      _placas = placas;
    });
  }

  Future<void> _cadastrarPlaca(String placa) async {
    if (!(await _dbHelper.existsPlaca(placa))) {
      showDialog(
        context: context,
        builder: (context) {
          String? condutor;
          String? cnh;
          String? cpf;
          String? observacao;
          String? fotoPath;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  2, // Ajusta a largura do diálogo
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Cadastrar Placa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: 'Condutor'),
                    onChanged: (value) {
                      condutor = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'CNH'),
                    onChanged: (value) {
                      cnh = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'CPF'),
                    onChanged: (value) {
                      cpf = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Observação'),
                    onChanged: (value) {
                      observacao = value;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 10),
                      Text('Anexar Imagem'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (condutor != null && observacao != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Placa cadastrada: $placa')),
                            );
                            _fetchPlacas(); // Atualiza a lista de placas
                          }
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                        child: Text('Cadastrar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                        child: Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Placa já cadastrada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placas Visadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(
                  labelText: 'Informe a Placa',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textCapitalization:
                    TextCapitalization.characters, // Força letras maiúsculas
                maxLength:
                    7, // Define o limite de caracteres para 7, sem espaços
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9]')), // Permite letras e números
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma placa válida';
                  }
                  if (!RegExp(r'^[A-Z]{3}[0-9][A-Z][0-9]{2}$') // Formato novo (AAA1A23)
                          .hasMatch(value.toUpperCase()) &&
                      !RegExp(r'^[A-Z]{3}[0-9]{4}$') // Formato antigo (AAA1234)
                          .hasMatch(value.toUpperCase())) {
                    return 'Formato de placa inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _cadastrarPlaca(_placaController.text.toUpperCase());
                    _placaController.clear(); // Limpa o campo após o cadastro
                  }
                },
                child: Text('Cadastrar Placa'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _placas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_placas[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
