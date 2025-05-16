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
  // Paleta de colores
  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);

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
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: const Text(
          'Gráfica de Gastos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _primaryColor))
              : _data.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pie_chart_outline, size: 50, color: _darkAccent),
                    const SizedBox(height: 16),
                    Text(
                      'No hay gastos para mostrar',
                      style: TextStyle(color: _darkAccent, fontSize: 18),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: _secondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _getMaxY(),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: _primaryColor.withOpacity(
                                    0.9,
                                  ),
                                  getTooltipItem: (
                                    group,
                                    groupIndex,
                                    rod,
                                    rodIndex,
                                  ) {
                                    final categoria =
                                        _data[group.x.toInt()]['categoria'];
                                    final total = rod.toY.toStringAsFixed(2);
                                    return BarTooltipItem(
                                      '$categoria\n\$$total',
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
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
                                    getTitlesWidget: _leftTitles,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine:
                                    (value) => FlLine(
                                      color: _lightBackground,
                                      strokeWidth: 1,
                                    ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _buildBarGroups(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final categoria = _data[index]['categoria'] as String;
                          final total =
                              (_data[index]['total'] as num).toDouble();
                          final color = _getCategoryColor(index);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            color: _secondaryColor,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                categoria,
                                style: TextStyle(
                                  color: _darkAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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

  Color _getCategoryColor(int index) {
    final colors = [
      _primaryColor,
      _successColor,
      _darkAccent,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];
    return colors[index % colors.length];
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
      final color = _getCategoryColor(index);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            color: color,
            width: 24,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: _lightBackground,
            ),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          categoria.length > 8 ? '${categoria.substring(0, 8)}...' : categoria,
          style: TextStyle(
            fontSize: 12,
            color: _darkAccent,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\$${value.toInt()}',
        style: TextStyle(color: _darkAccent, fontSize: 12),
      ),
    );
  }
}
