class PlacaVeiculo {
  final String placa;
  final String condutor;
  final String cnh;
  final String cpf;
  final String observacao;
  final String fotoPath;
  final DateTime dataCadastro;

  PlacaVeiculo({
    required this.placa,
    required this.condutor,
    required this.cnh,
    required this.cpf,
    required this.observacao,
    required this.fotoPath,
    required this.dataCadastro,
  });

  // Método para converter o objeto PlacaVeiculo em um mapa
  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'condutor': condutor,
      'cnh': cnh,
      'cpf': cpf,
      'observacao': observacao,
      'fotoPath': fotoPath,
      'dataCadastro':
          dataCadastro.toIso8601String(), // Convertendo a data para string
    };
  }
}
