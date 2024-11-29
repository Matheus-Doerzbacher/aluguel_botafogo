import 'package:aluguel_botafogo/controller/aluguel_controller.dart';
import 'package:aluguel_botafogo/main.dart';
import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  final Aluguel? aluguel;
  const FormPage({super.key, this.aluguel});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final Aluguel exemploAluguel = Aluguel(
    id: '1',
    pessoa: 'João da Silva',
    descricao: 'Apartamento 101',
    dia: DateTime.now(),
  );

  final TextEditingController _locatarioController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  final TextEditingController _formatDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.aluguel != null) {
      _locatarioController.text = widget.aluguel!.pessoa;
      _descricaoController.text = widget.aluguel!.descricao;
      _diaController.text = DateFormat('EEE dd \'de\' MMM \'de\' yyyy', 'pt_BR')
          .format(widget.aluguel!.dia)
          .split(' ')
          .map((word) => word == 'de' ? word : capitalize(word))
          .join(' ');
      _formatDateController.text = widget.aluguel!.dia.toString();
    }
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate() ||
        _formatDateController.text.isEmpty) {
      if (_formatDateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione uma data.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final Aluguel aluguel = Aluguel(
      id: widget.aluguel?.id ?? '',
      pessoa: _locatarioController.text,
      descricao: _descricaoController.text,
      dia: DateTime.parse(_formatDateController.text),
    );

    if (widget.aluguel != null) {
      Provider.of<AluguelController>(context, listen: false)
          .updateAluguel(aluguel);
    } else {
      Provider.of<AluguelController>(context, listen: false)
          .addAluguel(aluguel);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aluguel != null ? 'Editar' : 'Novo Aluguel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _locatarioController,
                decoration:
                    const InputDecoration(labelText: 'Nome do Locatário'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Adicione o nome do locatário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Adicione uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Data do Aluguel:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _formatDateController.text.isEmpty
                            ? DateTime.now()
                            : DateTime.parse(_formatDateController.text),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2050),
                        locale: const Locale('pt', 'BR'),
                      );
                      if (picked != null) {
                        setState(() {
                          _diaController.text = DateFormat(
                                  'EEE dd \'de\' MMM \'de\' yyyy', 'pt_BR')
                              .format(picked)
                              .split(' ')
                              .map((word) =>
                                  word == 'de' ? word : capitalize(word))
                              .join(' ');

                          _formatDateController.text = picked.toString();
                        });
                      }
                    },
                    child: Text(
                      _diaController.text.isEmpty
                          ? 'Selecione uma data'
                          : _diaController.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSubmit,
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
