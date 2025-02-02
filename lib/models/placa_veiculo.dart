class PlacaVeiculo {
  String placa;
  String condutor;
  String cnh;
  String cpf;
  String observacao;
  String fotoPath;
  DateTime dataCadastro;

  PlacaVeiculo({
    required this.placa,
    required this.condutor,
    required this.cnh,
    required this.cpf,
    required this.observacao,
    required this.fotoPath,
    required this.dataCadastro,
  });

  // Converte o mapa do banco de dados para o objeto PlacaVeiculo
  factory PlacaVeiculo.fromMap(Map<String, dynamic> map) {
    return PlacaVeiculo(
      placa: map['placa'],
      condutor: map['condutor'],
      cnh: map['cnh'],
      cpf: map['cpf'],
      observacao: map['observacao'],
      fotoPath: map['fotoPath'],
      dataCadastro: DateTime.parse(map['dataCadastro']),
    );
  }

  // Converte o objeto PlacaVeiculo para um mapa para inserção no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'condutor': condutor,
      'cnh': cnh,
      'cpf': cpf,
      'observacao': observacao,
      'fotoPath': fotoPath,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }
}
