import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_gm/models/database_helper.dart';
import 'package:note_gm/models/placa_veiculo.dart';

class PlacasVisadasView extends StatefulWidget {
  @override
  _PlacasVisadasViewState createState() => _PlacasVisadasViewState();
}

class _PlacasVisadasViewState extends State<PlacasVisadasView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placaController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  ValueNotifier<String?> _fotoPathNotifier = ValueNotifier<String?>(null);
  List<PlacaVeiculo> _placas = [];

  // Variáveis para armazenar dados inseridos
  String _condutor = '';
  String _cnh = '';
  String _cpf = '';
  String _observacao = '';

  @override
  void initState() {
    super.initState();
    _fetchPlacas(); // Carregar placas no início
  }

  Future<void> _fetchPlacas() async {
    List<String> placasStrings = await _dbHelper.getPlacas();
    List<PlacaVeiculo> placasVeiculo = placasStrings.map((placa) {
      return PlacaVeiculo(
        placa: placa,
        condutor: '',
        cnh: '',
        cpf: '',
        observacao: '',
        fotoPath: '',
        dataCadastro: DateTime.now(),
      );
    }).toList();

    setState(() {
      _placas = placasVeiculo;
    });
  }

  Future<void> _cadastrarPlaca(String placa) async {
    if (!(await _dbHelper.existsPlaca(placa))) {
      showDialog(
        context: context,
        builder: (context) {
          final _condutorController = TextEditingController(text: _condutor);
          final _cnhController = TextEditingController(text: _cnh);
          final _cpfController = TextEditingController(text: _cpf);
          final _observacaoController =
              TextEditingController(text: _observacao);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Cadastrar Placa',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    // Campos do Formulário
                    TextField(
                      controller: _condutorController,
                      decoration: InputDecoration(
                          labelText: 'Condutor',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        setState(() {
                          _condutor = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _cnhController,
                      decoration: InputDecoration(
                          labelText: 'CNH',
                          prefixIcon: Icon(Icons.card_membership),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _cnh = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _cpfController,
                      decoration: InputDecoration(
                          labelText: 'CPF',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _cpf = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _observacaoController,
                      decoration: InputDecoration(
                          labelText: 'Observação',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        setState(() {
                          _observacao = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Botão para tirar a foto
                    ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          _fotoPathNotifier.value = pickedFile.path;
                        }
                      },
                      child: Text('Tirar Foto do Veículo'),
                    ),
                    SizedBox(height: 10),

                    // Exibe a foto capturada
                    ValueListenableBuilder<String?>(
                      valueListenable: _fotoPathNotifier,
                      builder: (context, fotoPath, child) {
                        return fotoPath != null
                            ? Image.file(File(fotoPath),
                                height: 100, width: 100, fit: BoxFit.cover)
                            : Container();
                      },
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (_condutor.isNotEmpty &&
                                _cnh.isNotEmpty &&
                                _cpf.isNotEmpty &&
                                _observacao.isNotEmpty) {
                              PlacaVeiculo novaPlaca = PlacaVeiculo(
                                placa: placa,
                                condutor: _condutor,
                                observacao: _observacao,
                                cnh: _cnh,
                                cpf: _cpf,
                                fotoPath: _fotoPathNotifier.value ?? '',
                                dataCadastro: DateTime.now(),
                              );
                              await _dbHelper.insertPlaca(novaPlaca);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Placa cadastrada: $placa')));
                              _fetchPlacas();
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Preencha todos os campos')));
                            }
                          },
                          child: Text('Cadastrar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
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
      appBar: AppBar(title: Text('Placas Visadas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(
                    labelText: 'Informe a Placa', border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                maxLength: 7,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma placa válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _cadastrarPlaca(_placaController.text.toUpperCase());
                    _placaController.clear();
                  }
                },
                child: Text('Cadastrar Placa'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _placas.length,
                  itemBuilder: (context, index) {
                    PlacaVeiculo placaVeiculo = _placas[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(placaVeiculo.placa,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Data do cadastro: ${DateFormat('dd/MM/yyyy').format(placaVeiculo.dataCadastro)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            // Mostrar detalhes da placa
                          },
                        ),
                      ),
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
