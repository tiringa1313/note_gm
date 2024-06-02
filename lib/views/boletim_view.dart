import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/boletim.dart';
import '../models/database_helper.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

//sk-proj-IGbqxGYmhtEcRKPmRIRQT3BlbkFJS0cbJ7KlOVUmI46l4LMT

class BoletimView extends StatelessWidget {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController instrucoesController = TextEditingController();
  final String viatura;
  final String nomenclatura;

  BoletimView({required this.viatura, required this.nomenclatura});

  Future<void> corrigirTextoComIA(
      BuildContext context, String instrucoes) async {
    final apiKey = 'sk-proj-IGbqxGYmhtEcRKPmRIRQT3BlbkFJS0cbJ7KlOVUmI46l4LMT';
    final url = 'https://api.openai.com/v1/chat/completions';

    final encodedInstrucoes = Uri.encodeComponent(instrucoes);
    final encodedTexto = Uri.encodeComponent(descricaoController.text);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': '$encodedInstrucoes\n\nTexto: $encodedTexto'
          }
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
        'n': 1,
        'stop': null,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final corrigido = data['choices'][0]['message']['content'];
      descricaoController.text =
          corrigido.trim(); // Atualiza o texto no controller
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Texto corrigido com sucesso!')),
      );
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      print(
          'Erro ao corrigir o texto: ${response.reasonPhrase}. Detalhes: ${errorData['error']['message']}');
      throw Exception(
          'Falha ao corrigir o texto: ${response.reasonPhrase}. Detalhes: ${errorData['error']['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dataAtual = DateTime.now();
    int horas = dataAtual.hour;
    int minutos = dataAtual.minute;
    String dia = DateFormat('dd', 'pt_BR').format(dataAtual);
    String mesEAno = DateFormat('MMMM yyyy', 'pt_BR').format(dataAtual);
    String dataFormatada = '$dia de $mesEAno';
    String descricao =
        "Por volta das $horas horas e $minutos minutos do dia $dataFormatada, a guarnição da viatura $viatura - $nomenclatura,";

    descricaoController.text = descricao;

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Boletim'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título do Atendimento'),
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 20),
            TextField(
              controller: instrucoesController,
              decoration: InputDecoration(labelText: 'Instruções para IA'),
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 20),
            Text(
              'Descrição',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descricaoController,
                  maxLines: 14,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String texto = descricaoController.text;
                  String instrucoes = instrucoesController.text;
                  try {
                    await corrigirTextoComIA(context, instrucoes);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Falha ao corrigir o texto: $e')),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 8.0),
                    Text('Corrigir com IA'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: descricaoController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Boletim copiado para a área de transferência')),
                    );
                  },
                  icon: Icon(Icons.content_copy),
                  label: Text('Copiar Boletim'),
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String titulo = tituloController.text;
                      String descricao = descricaoController.text;

                      // Salvar o boletim
                    },
                    icon: Icon(Icons.save),
                    label: Text('Salvar Boletim'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
