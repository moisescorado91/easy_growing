// models/goal.dart

class Goal {
  String id;
  String title;
  double targetAmount;
  double currentAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
}
