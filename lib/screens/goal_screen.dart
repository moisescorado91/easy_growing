import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import 'package:uuid/uuid.dart';

class GoalScreen extends StatefulWidget {
  final GoalService goalService;

  GoalScreen({required this.goalService});

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late AnimationController _progressAnimationController;

  // Paleta de colores
  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _addGoal() {
    final title = _titleController.text;
    final target = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || target <= 0) return;

    final goal = Goal(
      id: Uuid().v4(),
      title: title,
      targetAmount: target,
    );

    setState(() {
      widget.goalService.addGoal(goal);
      _progressAnimationController.reset();
      _progressAnimationController.forward();
    });

    _titleController.clear();
    _amountController.clear();
  }

  void _addMoneyToGoal(String id) {
    showDialog(
      context: context,
      builder: (ctx) {
        final moneyController = TextEditingController();
        return AlertDialog(
          backgroundColor: _lightBackground,
          title: Text('Agregar dinero', style: TextStyle(color: _primaryColor)),
          content: TextField(
            controller: moneyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad',
              labelStyle: TextStyle(color: _primaryColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _primaryColor),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancelar', style: TextStyle(color: _primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _successColor,
              ),
              onPressed: () {
                final amount = double.tryParse(moneyController.text) ?? 0.0;
                if (amount > 0) {
                  setState(() {
                    widget.goalService.addMoney(id, amount);
                    _progressAnimationController.reset();
                    _progressAnimationController.forward();
                  });
                }
                Navigator.of(ctx).pop();
              },
              child: Text('Agregar'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goals = widget.goalService.goals;
    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: Text('Metas'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: _secondaryColor,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la meta',
                        labelStyle: TextStyle(color: _primaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _primaryColor),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto a lograr',
                        labelStyle: TextStyle(color: _primaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _addGoal,
                      child: Text('Agregar Meta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (ctx, i) {
                final goal = goals[i];
                return AnimatedBuilder(
                  animation: _progressAnimationController,
                  builder: (context, child) {
                    return Card(
                      color: _secondaryColor,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(goal.title, style: TextStyle(color: _darkAccent)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: goal.progress * _progressAnimationController.value,
                                color: _primaryColor,
                                backgroundColor: _lightBackground,
                                minHeight: 8,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${goal.currentAmount.toStringAsFixed(2)} / ${goal.targetAmount.toStringAsFixed(2)}',
                              style: TextStyle(color: _darkAccent),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.attach_money, color: _successColor),
                          onPressed: () => _addMoneyToGoal(goal.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}