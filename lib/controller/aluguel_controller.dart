import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:aluguel_botafogo/repository/functions_repository.dart';
import 'package:flutter/material.dart';

class AluguelController extends ChangeNotifier {
  AluguelController() {
    fetchAlugueis();
  }

  List<Aluguel> _alugueis = [];

  List<Aluguel> get alugueis => _alugueis;

  Future<void> fetchAlugueis() async {
    _alugueis = await getAlugueisRepository();
    notifyListeners();
  }

  Future<void> addAluguel(Aluguel aluguel) async {
    final newAluguel = await addAluguelRepository(aluguel);

    _alugueis.add(newAluguel);
    notifyListeners();
  }

  Future<void> removeAluguel(int index) async {
    await deleteAluguelRepository(_alugueis[index].id!);

    _alugueis.removeAt(index);
    notifyListeners();
  }

  Future<void> updateAluguel(Aluguel aluguel) async {
    await updateAluguelRepository(aluguel);

    final index = _alugueis.indexWhere((aluguel) => aluguel.id == aluguel.id);
    if (index != -1) {
      _alugueis[index] = aluguel;
      notifyListeners();
    }
  }
}
