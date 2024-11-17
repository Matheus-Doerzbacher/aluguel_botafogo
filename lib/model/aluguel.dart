class Aluguel {
  final String? id;
  final String pessoa;
  final String descricao;
  final DateTime dia;

  Aluguel(this.id, this.pessoa, this.descricao, this.dia);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pessoa': pessoa,
      'descricao': descricao,
      'dia': dia.toIso8601String(),
    };
  }

  factory Aluguel.fromJson(Map<String, dynamic> json) {
    return Aluguel(
      json['id'],
      json['pessoa'],
      json['descricao'],
      DateTime.parse(json['dia']),
    );
  }

  Aluguel copyWith({
    String? id,
    String? pessoa,
    String? descricao,
    DateTime? dia,
  }) {
    return Aluguel(
      id ?? this.id,
      pessoa ?? this.pessoa,
      descricao ?? this.descricao,
      dia ?? this.dia,
    );
  }
}
