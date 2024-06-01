import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/database_helper.dart';
import '../models/boletim.dart';

class BoletimView extends StatelessWidget {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtém a data atual
    DateTime dataAtual = DateTime.now();

    // Obtém as horas e minutos atuais
    int horas = dataAtual.hour;
    int minutos = dataAtual.minute;

    // Formata a data para o formato desejado ("dia de mês de ano")
    String dataFormatada =
        DateFormat('dd MMMM yyyy', 'pt_BR').format(dataAtual);

    // Define a descrição com as horas, minutos e a data
    String descricao =
        "Por volta das $horas horas e $minutos minutos do dia $dataFormatada, a guarnição da viatura ";

    // Define o texto inicial no controlador do campo de descrição
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
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Adicionar lógica para corrigir com IA
                    },
                    child: Text('Corrigir com IA'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String titulo = tituloController.text;
                      String descricao = descricaoController.text;

                      Boletim boletim = Boletim.create(
                        data: DateTime.now(),
                        tituloAtendimento: titulo,
                        descricao: descricao,
                      );

                      await DatabaseHelper().insertBoletim(boletim);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Boletim salvo com sucesso!')),
                      );

                      // Retorna um valor para indicar que o boletim foi salvo
                      Navigator.pop(context, true);
                    },
                    child: Text('Salvar Boletim'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
