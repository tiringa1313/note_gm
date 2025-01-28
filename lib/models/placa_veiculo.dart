class PlacaVeiculo {
  String _placa;
  String _condutor;
  String _observacao;
  String _cnh;
  String _cpf;
  String _fotoPath;
  DateTime _dataCadastro; // Novo campo de data

  // Construtor
  PlacaVeiculo({
    required String placa,
    required String condutor,
    required String observacao,
    required String cnh,
    required String cpf,
    required String fotoPath,
    required DateTime dataCadastro, // Parâmetro para a data
  })  : _placa = placa,
        _condutor = condutor,
        _observacao = observacao,
        _cnh = cnh,
        _cpf = cpf,
        _fotoPath = fotoPath,
        _dataCadastro = dataCadastro; // Inicialização da data

  // Getters
  String get placa => _placa;
  String get condutor => _condutor;
  String get observacao => _observacao;
  String get cnh => _cnh;
  String get cpf => _cpf;
  String get fotoPath => _fotoPath;
  DateTime get dataCadastro => _dataCadastro; // Getter para a data

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

  set dataCadastro(DateTime value) {
    // Setter para a data
    _dataCadastro = value;
  }
}
