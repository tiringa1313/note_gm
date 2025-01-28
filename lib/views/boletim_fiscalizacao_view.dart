import 'package:flutter/material.dart';

class BoletimFiscalizacaoView extends StatefulWidget {
  @override
  _BoletimFiscalizacaoViewState createState() =>
      _BoletimFiscalizacaoViewState();
}

class _BoletimFiscalizacaoViewState extends State<BoletimFiscalizacaoView> {
  // Controladores de texto para os campos do formulário
  final TextEditingController _nomeCondutorController = TextEditingController();
  final TextEditingController _placaVeiculoController = TextEditingController();
  final TextEditingController _ruaAbordagemController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _motivoAbordagemController =
      TextEditingController();
  final TextEditingController _medidasTomadasController =
      TextEditingController();

  // Função para gerar o boletim usando IA
  void _gerarBoletimIA() {
    final nomeCondutor = _nomeCondutorController.text;
    final placaVeiculo = _placaVeiculoController.text;
    final ruaAbordagem = _ruaAbordagemController.text;
    final numero = _numeroController.text;
    final motivoAbordagem = _motivoAbordagemController.text;
    final medidasTomadas = _medidasTomadasController.text;

    // Verificar se todos os campos foram preenchidos
    if (nomeCondutor.isNotEmpty &&
        placaVeiculo.isNotEmpty &&
        ruaAbordagem.isNotEmpty &&
        numero.isNotEmpty &&
        motivoAbordagem.isNotEmpty &&
        medidasTomadas.isNotEmpty) {
      // Aqui, a IA geraria o boletim automaticamente.
      // Para fins de exemplo, vamos apenas mostrar um Snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Boletim gerado com sucesso!')),
      );
      // Exemplo de como acessar os dados coletados:
      print('Nome do Condutor: $nomeCondutor');
      print('Placa do Veículo: $placaVeiculo');
      print('Rua da Abordagem: $ruaAbordagem');
      print('Número: $numero');
      print('Motivo da Abordagem: $motivoAbordagem');
      print('Medidas Tomadas: $medidasTomadas');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletim de Fiscalização'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Nome do Condutor
              _buildTextField(
                controller: _nomeCondutorController,
                label: 'Nome do Condutor',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Placa do Veículo
              _buildTextField(
                controller: _placaVeiculoController,
                label: 'Placa do Veículo',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Rua da Abordagem
              _buildTextField(
                controller: _ruaAbordagemController,
                label: 'Rua da Abordagem',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Número
              _buildTextField(
                controller: _numeroController,
                label: 'Número',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Motivo da Abordagem
              _buildTextField(
                controller: _motivoAbordagemController,
                label: 'Motivo da Abordagem',
                maxLines: 3, // Permite mais linhas de texto
              ),
              SizedBox(height: 16.0),

              // Campo Medidas Tomadas
              _buildTextField(
                controller: _medidasTomadasController,
                label: 'Medidas Tomadas',
                maxLines: 3, // Permite mais linhas de texto
              ),
              SizedBox(height: 32.0),

              // Botão para gerar boletim pela IA
              Center(
                child: ElevatedButton(
                  onPressed: _gerarBoletimIA,
                  child: Text('Gerar Boletim pela IA'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Função que retorna um TextField estilizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(0.1), // Cor de fundo suave
      ),
      maxLines: maxLines,
      keyboardType: TextInputType.text,
    );
  }
}
