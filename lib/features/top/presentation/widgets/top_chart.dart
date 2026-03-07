import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class TopChartIndicator extends StatefulWidget {
  final List<SongModel> topSongs;
  const TopChartIndicator({super.key, required this.topSongs});

  @override
  State<TopChartIndicator> createState() => _TopChartIndicatorState();
}

class _TopChartIndicatorState extends State<TopChartIndicator> {
  int? _touchedIndex;
  OverlayEntry? _tooltipEntry;

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _removeTooltip() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

  void _showTooltip(
    BuildContext context,
    Offset position,
    int index,
    Color color,
  ) {
    _removeTooltip();

    final song = widget.topSongs[index];
    const tooltipSize = 60.0;

    final barChartHeight = 250.0;
    final maxY = widget.topSongs
            .map((e) => e.playCount.toDouble())
            .reduce((a, b) => a > b ? a : b) *
        1.1;
    final value = widget.topSongs[index].playCount.toDouble();
    final barTop = position.dy + (1 - value / maxY) * barChartHeight;

    double top = barTop - tooltipSize + 20;

    _tooltipEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 90 * (index + 1),
        top: top,
        width: tooltipSize,
        height: tooltipSize,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                song.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey,
                  child: const Icon(
                    Icons.music_note,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_tooltipEntry!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topSongs.isEmpty) return const SizedBox.shrink();

    final maxCount = widget.topSongs
        .map((e) => e.playCount.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final colors = [
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.tealAccent,
      Colors.indigoAccent,
      Colors.yellowAccent,
      Colors.amberAccent,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 10 thịnh hành nhất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount * 1.1,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                  ),
                  touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                    if (response == null || response.spot == null) {
                      _removeTooltip();
                      setState(() => _touchedIndex = null);
                      return;
                    }
                    final index = response.spot!.touchedBarGroupIndex;
                    if (index != _touchedIndex) {
                      setState(() => _touchedIndex = index);
                      final renderBox = context.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      final double barWidth = 16;
                      final double totalWidth = MediaQuery.of(context).size.width - 32;
                      final double spacing = (totalWidth - (barWidth * widget.topSongs.length)) /
                          (widget.topSongs.length - 1);
                      final double barCenterX = 16 +
                          (index * (barWidth + spacing)) +
                          barWidth / 2;
                      final Offset barCenter = Offset(barCenterX, position.dy);
                      _showTooltip(
                        context,
                        barCenter,
                        index,
                        colors[index % colors.length],
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= widget.topSongs.length)
                          return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${value.toInt() + 1}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      reservedSize: 20,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: List.generate(widget.topSongs.length, (index) {
                  final isSelected = index == _touchedIndex;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: widget.topSongs[index].playCount.toDouble(),
                        color: colors[index % colors.length],
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        borderSide: isSelected
                            ? const BorderSide(color: Colors.white, width: 2)
                            : BorderSide.none,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}