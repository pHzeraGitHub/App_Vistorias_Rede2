class Tarefa {
  final int id;
  final String nome;
  final String descricao;

  Tarefa({required this.id, required this.nome, required this.descricao});

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
    );
  }
}
