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
}