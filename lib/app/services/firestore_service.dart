import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/habit.dart';

class FirestoreService extends GetxService {
  static FirestoreService get to => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Habit>> getHabitsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Habit.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addHabit(String uid, Habit habit) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .add(habit.toMap());
  }

  Future<void> updateHabit(String uid, Habit habit) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  Future<void> deleteHabit(String uid, String habitId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
}
