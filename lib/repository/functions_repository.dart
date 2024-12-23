import 'package:aluguel_botafogo/model/aluguel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Aluguel>> getAlugueisRepository() {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('aluguel').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Aluguel.fromJson(doc.data())).toList();
  });
}

Future<Aluguel> addAluguelRepository(Aluguel aluguel) async {
  final firestore = FirebaseFirestore.instance;
  final docRef = await firestore.collection('aluguel').add(aluguel.toJson());
  await docRef.update({'id': docRef.id});
  return aluguel.copyWith(id: docRef.id);
}

Future<void> deleteAluguelRepository(String id) async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('aluguel').doc(id).delete();
}

Future<void> updateAluguelRepository(Aluguel aluguel) async {
  final firestore = FirebaseFirestore.instance;
  await firestore
      .collection('aluguel')
      .doc(aluguel.id)
      .update(aluguel.toJson());
}
