// services/goal_service.dart

import '../models/goal.dart';

class GoalService {
  final List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  void addGoal(Goal goal) {
    _goals.add(goal);
  }

  void addMoney(String goalId, double amount) {
    final goal = _goals.firstWhere((g) => g.id == goalId);
    goal.currentAmount += amount;
  }
}
