import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:aluguel_botafogo/repository/functions_repository.dart';
import 'package:flutter/foundation.dart';

class AluguelController extends ChangeNotifier {
  AluguelController();

  Stream<List<Aluguel>> streamAlugueis() => getAlugueisRepository();

  Future<void> addAluguel(Aluguel aluguel) async {
    try {
      await addAluguelRepository(aluguel);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeAluguel(String id) async {
    try {
      await deleteAluguelRepository(id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateAluguel(Aluguel aluguel) async {
    try {
      await updateAluguelRepository(aluguel);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
