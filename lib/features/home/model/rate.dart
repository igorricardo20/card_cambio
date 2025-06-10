class Rate {
  final String taxaTipoGasto;
  final String taxaData;
  final double taxaConversao;
  final String taxaDivulgacaoDataHora;

  Rate({
    required this.taxaTipoGasto,
    required this.taxaData,
    required this.taxaConversao,
    required this.taxaDivulgacaoDataHora,
  });

  factory Rate.blank() {
    return Rate(
      taxaTipoGasto: '',
      taxaData: '',
      taxaConversao: 0.0,
      taxaDivulgacaoDataHora: '',
    );
  }

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      taxaTipoGasto: json['taxaTipoGasto'],
      taxaData: json['taxaData'],
      taxaConversao: json['taxaConversao'] is String
          ? double.parse(json['taxaConversao'])
          : json['taxaConversao'].toDouble(),
      taxaDivulgacaoDataHora: json['taxaDivulgacaoDataHora'],
    );
  }

  Rate copyWith({
    String? taxaTipoGasto,
    String? taxaData,
    double? taxaConversao,
    String? taxaDivulgacaoDataHora,
  }) {
    return Rate(
      taxaTipoGasto: taxaTipoGasto ?? this.taxaTipoGasto,
      taxaData: taxaData ?? this.taxaData,
      taxaConversao: taxaConversao ?? this.taxaConversao,
      taxaDivulgacaoDataHora: taxaDivulgacaoDataHora ?? this.taxaDivulgacaoDataHora,
    );
  }
}