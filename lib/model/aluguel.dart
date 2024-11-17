class Aluguel {
  final String? id;
  final String pessoa;
  final String descricao;
  final DateTime dia;

  Aluguel({
    required this.id,
    required this.pessoa,
    required this.descricao,
    required this.dia,
  });

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
      id: json['id'],
      pessoa: json['pessoa'],
      descricao: json['descricao'],
      dia: DateTime.parse(json['dia']),
    );
  }

  Aluguel copyWith({
    String? id,
    String? pessoa,
    String? descricao,
    DateTime? dia,
  }) {
    return Aluguel(
      id: id ?? this.id,
      pessoa: pessoa ?? this.pessoa,
      descricao: descricao ?? this.descricao,
      dia: dia ?? this.dia,
    );
  }
}
