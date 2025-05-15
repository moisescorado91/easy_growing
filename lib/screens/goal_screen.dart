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

class _GoalScreenState extends State<GoalScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _addGoal() {
    final title = _titleController.text;
    final target = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || target <= 0) return;

    final goal = Goal(id: Uuid().v4(), title: title, targetAmount: target);

    setState(() {
      widget.goalService.addGoal(goal);
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
          title: Text('Agregar dinero'),
          content: TextField(
            controller: moneyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final amount = double.tryParse(moneyController.text) ?? 0.0;
                if (amount > 0) {
                  setState(() {
                    widget.goalService.addMoney(id, amount);
                  });
                }
                Navigator.of(ctx).pop();
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goals = widget.goalService.goals;
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            ); // ← Esto hace que vuelvas a la pantalla anterior
          },
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Nombre de la meta'),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Monto a lograr'),
                ),
                ElevatedButton(
                  onPressed: _addGoal,
                  child: Text('Agregar Meta'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (ctx, i) {
                final goal = goals[i];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(goal.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: goal.progress),
                        SizedBox(height: 4),
                        Text(
                          '${goal.currentAmount.toStringAsFixed(2)} / ${goal.targetAmount.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.attach_money),
                      onPressed: () => _addMoneyToGoal(goal.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
