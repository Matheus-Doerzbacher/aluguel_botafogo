import 'package:aluguel_botafogo/controller/aluguel_controller.dart';
import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final AluguelController controller =
        Provider.of<AluguelController>(context);
    Intl.defaultLocale = 'pt_BR';
    final List<Aluguel> alugueis = controller.alugueis;

    // Ordenar os alugueis pela data
    alugueis.sort((a, b) => a.dia.compareTo(b.dia));

    // Organizar os alugueis por mês
    final Map<String, List<Aluguel>> alugueisPorMes = {};
    for (var aluguel in alugueis) {
      final mesAno = DateFormat('MMMM yyyy', 'pt_BR').format(aluguel.dia);
      if (!alugueisPorMes.containsKey(mesAno)) {
        alugueisPorMes[mesAno] = [];
      }
      alugueisPorMes[mesAno]!.add(aluguel);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aluguel Botafogo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: alugueis.isNotEmpty
            ? ListView(
                children: alugueisPorMes.entries.expand((entry) {
                  final mesAno = entry.key;
                  final alugueisDoMes = entry.value;
                  return [
                    Text(
                      mesAno,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...alugueisDoMes.map((aluguel) {
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmação'),
                                  content: const Text(
                                      'Tem certeza que deseja excluir este item?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              controller
                                  .removeAluguel(alugueis.indexOf(aluguel));
                            } else {
                              setState(() {});
                            }
                          }
                        },
                        background: const Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 32,
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/form',
                                  arguments: aluguel);
                            },
                            title: Text(aluguel.pessoa),
                            subtitle: Text(aluguel.descricao),
                            trailing: Text(
                              DateFormat(
                                      'EEE dd \'de\' MMM \'de\' yyyy', 'pt_BR')
                                  .format(aluguel.dia)
                                  .split(' ')
                                  .map((word) =>
                                      word == 'de' ? word : capitalize(word))
                                  .join(' '),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ];
                }).toList(),
              )
            : const Center(child: Text('Nenhum aluguel encontrado')),
      ),
    );
  }
}
