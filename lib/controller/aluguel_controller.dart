import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:aluguel_botafogo/repository/functions_repository.dart';
import 'package:flutter/foundation.dart';

class AluguelController extends ChangeNotifier {
  AluguelController() {
    fetchAlugueis();
  }

  List<Aluguel> _alugueis = [];
  bool _isLoading = false;

  List<Aluguel> get alugueis => _alugueis;

  bool get isLoading => _isLoading;

  Future<void> fetchAlugueis() async {
    _isLoading = true;
    notifyListeners();
    try {
      _alugueis = await getAlugueisRepository();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAluguel(Aluguel aluguel) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newAluguel = await addAluguelRepository(aluguel);

      _alugueis.add(newAluguel);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeAluguel(int index) async {
    _isLoading = true;
    notifyListeners();
    try {
      await deleteAluguelRepository(_alugueis[index].id!);

      _alugueis.removeAt(index);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAluguel(Aluguel aluguel) async {
    _isLoading = true;
    notifyListeners();
    try {
      await updateAluguelRepository(aluguel);

      final index = _alugueis.indexWhere((aluguel) => aluguel.id == aluguel.id);
      if (index != -1) {
        _alugueis[index] = aluguel;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
