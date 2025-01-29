import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_gm/models/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:note_gm/models/placa_veiculo.dart';
import 'package:image_picker/image_picker.dart'; // Importando o ImagePicker

class PlacasVisadasView extends StatefulWidget {
  @override
  _PlacasVisadasViewState createState() => _PlacasVisadasViewState();
}

class _PlacasVisadasViewState extends State<PlacasVisadasView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placaController = TextEditingController();
  List<PlacaVeiculo> _placas =
      []; // Lista para armazenar objetos do tipo PlacaVeiculo
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Instância do DatabaseHelper

  // Usando ValueNotifier para o caminho da foto
  ValueNotifier<String?> _fotoPathNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _fetchPlacas(); // Busca placas ao iniciar a view
  }

  Future<void> _fetchPlacas() async {
    // Obtém a lista de placas (strings)
    List<String> placasStrings = await _dbHelper.getPlacas();

    // Converte a lista de strings em uma lista de objetos PlacaVeiculo
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
          final _condutorController = TextEditingController();
          final _cnhController = TextEditingController();
          final _cpfController = TextEditingController();
          final _observacaoController = TextEditingController();

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
                    Text(
                      'Cadastrar Placa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Campos do Formulário
                    TextField(
                      controller: _condutorController,
                      decoration: InputDecoration(
                        labelText: 'Condutor',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _cnhController,
                      decoration: InputDecoration(
                        labelText: 'CNH',
                        prefixIcon: Icon(Icons.card_membership),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _cpfController,
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _observacaoController,
                      decoration: InputDecoration(
                        labelText: 'Observação',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Botão para tirar a foto
                    ElevatedButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.camera, // Usando a câmera
                        );
                        if (pickedFile != null) {
                          print(
                              'Caminho da foto: ${pickedFile.path}'); // Verifique o caminho da foto no console
                          _fotoPathNotifier.value =
                              pickedFile.path; // Armazena o caminho da foto
                        }
                      },
                      child: Text('Tirar Foto do Veículo'),
                    ),
                    SizedBox(height: 10),

                    // Usando ValueListenableBuilder para atualizar a imagem
                    ValueListenableBuilder<String?>(
                      valueListenable: _fotoPathNotifier,
                      builder: (context, fotoPath, child) {
                        return fotoPath != null
                            ? Image.file(
                                File(fotoPath),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Container();
                      },
                    ),

                    SizedBox(height: 20),
                    // Botões de Ação
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (_condutorController.text.isNotEmpty &&
                                _cnhController.text.isNotEmpty &&
                                _cpfController.text.isNotEmpty &&
                                _observacaoController.text.isNotEmpty) {
                              // Cria um objeto PlacaVeiculo com a foto
                              PlacaVeiculo novaPlaca = PlacaVeiculo(
                                placa: placa,
                                condutor: _condutorController.text,
                                observacao: _observacaoController.text,
                                cnh: _cnhController.text,
                                cpf: _cpfController.text,
                                fotoPath: _fotoPathNotifier.value ??
                                    '', // Foto do veículo
                                dataCadastro: DateTime.now(),
                              );
                              await _dbHelper.insertPlaca(novaPlaca as String);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Placa cadastrada: $placa')));
                              _fetchPlacas(); // Atualiza a lista de placas
                              Navigator.of(context).pop(); // Fecha o diálogo
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
                            Navigator.of(context).pop(); // Fecha o diálogo
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
              // Campo de entrada de placa
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(
                  labelText: 'Informe a Placa',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                textCapitalization:
                    TextCapitalization.characters, // Força letras maiúsculas
                maxLength: 7, // Define o limite de caracteres para 7
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9]')), // Permite letras e números
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma placa válida';
                  }
                  // Valida os dois formatos de placa
                  if (!RegExp(r'^[A-Z]{3}[0-9][A-Z][0-9]{2}$')
                          .hasMatch(value.toUpperCase()) &&
                      !RegExp(r'^[A-Z]{3}[0-9]{4}$')
                          .hasMatch(value.toUpperCase())) {
                    return 'Formato de placa inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Botão de cadastrar placa - centralizado
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _cadastrarPlaca(_placaController.text.toUpperCase());
                      _placaController.clear(); // Limpa o campo após o cadastro
                    }
                  },
                  child: Text('Cadastrar Placa'),
                ),
              ),
              SizedBox(height: 20),
              // Exibe a lista de placas
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
                        title: Text(
                          placaVeiculo.placa,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Data do cadastro: ${DateFormat('dd/MM/yyyy').format(placaVeiculo.dataCadastro)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            _mostrarDetalhesPlaca(placaVeiculo);
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

  // Função para mostrar os detalhes da placa
  void _mostrarDetalhesPlaca(PlacaVeiculo placaVeiculo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes da Placa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Placa: ${placaVeiculo.placa}'),
              Text('Condutor: ${placaVeiculo.condutor}'),
              Text('Observação: ${placaVeiculo.observacao}'),
              // Exibir a foto, se existir
              placaVeiculo.fotoPath.isNotEmpty
                  ? Image.file(File(placaVeiculo.fotoPath),
                      height: 100, width: 100)
                  : Container(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
