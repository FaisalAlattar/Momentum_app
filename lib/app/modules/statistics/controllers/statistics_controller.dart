import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import '../../../data/models/habit.dart';

class StatisticsController extends GetxController {
  final authService = AuthService.to;

  final RxList<Habit> habits = <Habit>[].obs;

  @override
  void onInit() {
    super.onInit();
    final user = authService.firebaseUser.value;
    if (user != null) {
      FirestoreService.to.getHabitsStream(user.uid).listen((event) {
        habits.value = event;
      });
    }
  }

  List<MapEntry<String, int>> get habitStats {
    final Map<String, int> stats = {};
    final Map<String, String> originalNames = {};

    for (var habit in habits) {
      final trimmedName = habit.name.trim();
      final lowerName = trimmedName.toLowerCase();
      
      if (!originalNames.containsKey(lowerName)) {
        originalNames[lowerName] = trimmedName;
      }
      
      stats[lowerName] = (stats[lowerName] ?? 0) + habit.completedCount;
    }

    final result = stats.entries.map((e) {
      return MapEntry(originalNames[e.key]!, e.value);
    }).toList();

    result.sort((a, b) => b.value.compareTo(a.value));
    
    return result;
  }
}
