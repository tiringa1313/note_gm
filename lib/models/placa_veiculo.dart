class PlacaVeiculo {
  String _placa;
  String _condutor;
  String _observacao;
  String _cnh;
  String _cpf;
  String _fotoPath;

  // Construtor
  PlacaVeiculo({
    required String placa,
    required String condutor,
    required String observacao,
    required String cnh,
    required String cpf,
    required String fotoPath,
  })  : _placa = placa,
        _condutor = condutor,
        _observacao = observacao,
        _cnh = cnh,
        _cpf = cpf,
        _fotoPath = fotoPath;

  // Getters
  String get placa => _placa;
  String get condutor => _condutor;
  String get observacao => _observacao;
  String get cnh => _cnh;
  String get cpf => _cpf;
  String get fotoPath => _fotoPath;

  // Setters
  set placa(String value) {
    _placa = value;
  }

  set condutor(String value) {
    _condutor = value;
  }

  set observacao(String value) {
    _observacao = value;
  }

  set cnh(String value) {
    _cnh = value;
  }

  set cpf(String value) {
    _cpf = value;
  }

  set fotoPath(String value) {
    _fotoPath = value;
  }
}
