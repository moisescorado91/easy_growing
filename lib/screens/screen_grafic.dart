import 'package:easy_growing/services/gasto_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class ScreenGrafic extends StatefulWidget {
  final GastoService gastoService;

  const ScreenGrafic({Key? key, required this.gastoService}) : super(key: key);

  @override
  _ScreenGraficState createState() => _ScreenGraficState();
}

class _ScreenGraficState extends State<ScreenGrafic> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await widget.gastoService.obtenerMontosPorCategoria();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Gastos por Categoría'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _data.isEmpty
                ? const Center(child: Text('No hay gastos para mostrar'))
                : Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _getMaxY(),
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: _bottomTitles,
                                reservedSize: 42,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: _getInterval(),
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _buildBarGroups(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final categoria = _data[index]['categoria'] as String;
                          final total =
                              (_data[index]['total'] as num).toDouble();

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(categoria),
                              trailing: Text('\$${total.toStringAsFixed(2)}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  double _getMaxY() {
    final maxTotal = _data
        .map((e) => (e['total'] as num).toDouble())
        .fold<double>(0, (prev, el) => el > prev ? el : prev);
    return (maxTotal * 1.2).ceilToDouble();
  }

  double _getInterval() {
    final maxY = _getMaxY();
    if (maxY <= 10) return 1;
    if (maxY <= 50) return 5;
    if (maxY <= 100) return 10;
    return 20;
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _data.asMap().entries.map((entry) {
      final index = entry.key;
      final total = (entry.value['total'] as num).toDouble();
      final color = Colors.primaries[index % Colors.primaries.length];

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            color: color,
            width: 22,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _data.length) return Container();
    final categoria = _data[index]['categoria'] as String;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        categoria.length > 8 ? '${categoria.substring(0, 8)}...' : categoria,
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }
}
