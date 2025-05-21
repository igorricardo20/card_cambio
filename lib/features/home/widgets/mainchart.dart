import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:intl/intl.dart';
import 'package:card_cambio/l10n/app_localizations.dart';

class MainChart extends StatefulWidget {
  final Map<String, List<Rate>> rates;

  const MainChart({
    super.key,
    required this.rates,
  });

  @override
  MainChartState createState() => MainChartState();
}

class MainChartState extends State<MainChart> {
  int selectedDays = 16;
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    _disableAnimationAfterDelay(); // Automatically disable animation
  }

  void _disableAnimationAfterDelay() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showAnimation = false;
      }); 
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle Buttons
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 6, top: 2), // Slightly less bottom, add a little top
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildToggleButton(AppLocalizations.of(context)!.period_1, 16),
              const SizedBox(width: 6), // Slightly less space
              _buildToggleButton(AppLocalizations.of(context)!.period_2, 30),
              const SizedBox(width: 6),
              _buildToggleButton(AppLocalizations.of(context)!.max, 60),
            ],
          ),
        ),
        Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8), // Add padding for a modern look
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(width: 0),
                dateFormat: DateFormat.MMMd(AppLocalizations.of(context)!.localeName),
                intervalType: DateTimeIntervalType.auto,
                edgeLabelPlacement: EdgeLabelPlacement.shift, // Prevent x-axis label overflow
              ),
              primaryYAxis: NumericAxis(
                isVisible: true,
                numberFormat: NumberFormat.currency(
                  symbol: 'R\$ ',
                  decimalDigits: 2,
                ),
                majorGridLines: MajorGridLines(color: Theme.of(context).dividerColor, width: 0.0),
                interval: 0.1,
              ),
              onActualRangeChanged: (ActualRangeChangedArgs args) {
                if (args.orientation == AxisOrientation.vertical) {
                  double min = args.actualMin is num ? args.actualMin.toDouble() : 0;
                  double max = args.actualMax is num ? args.actualMax.toDouble() : 0;

                  double range = max - min;
                  if (range > 0) {
                    double interval = range / 5;
                    args.visibleInterval = interval;

                    // Ensure the maximum value is included
                    if (max % interval != 0) {
                      args.visibleMax = max + (interval - (max % interval));
                    }
                  }
                }
              },
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.scroll,
              ),
              series: _getSeries(widget.rates),
              tooltipBehavior: TooltipBehavior(enable: false),
              trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipAlignment: ChartAlignment.near,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  enable: true,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                  textStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  borderWidth: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, int days) {
    final bool isSelected = selectedDays == days;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color selectedColor = isDark ? Colors.white : Colors.black;
    final Color unselectedTextColor = Colors.grey[600]!;
    final Color unselectedBgColor = Theme.of(context).cardColor;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            selectedDays = days;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.transparent,
            width: 2.2,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedBgColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 2.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.18),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: isSelected ? (isDark ? Colors.black : Colors.white) : unselectedTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SplineSeries<ChartData, DateTime>> _getSeries(Map<String, List<Rate>> rates) {
    if (rates.isEmpty) {
      return [];
    }

    final DateTime rangeStart = DateTime.now().subtract(Duration(days: selectedDays));
    final DateTime rangeEnd = DateTime.now().subtract(const Duration(days: 1));

    final Map<String, Color> bankColors = {
      'nubank': Color(0xFF820AD1),
      'itau': Colors.orange,
      'c6': Colors.black,
      'bb': Color(0xFFFFCC29),
      'caixa': Color(0xFF005CA9), // Caixa blue
      'safra': Color(0xFF2B2D42), // Safra deep blue
    };

    return rates.entries.map((entry) {
      final bankName = entry.key;
      final rateList = entry.value;

      // Adjust rangeStart for Itau
      final DateTime adjustedRangeStart = bankName == 'itau' ? rangeStart.add(const Duration(days: 1)) : rangeStart;

      final filteredData = rateList.where((rate) {
        final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
        return dateTime.isAfter(adjustedRangeStart) && dateTime.isBefore(rangeEnd);
      }).toList();

      final chartData = filteredData.map((rate) {
        final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
        final dayLevelDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        return ChartData(dayLevelDate, rate.taxaConversao);
      }).toList();

      final Color seriesColor = bankColors[bankName] ?? Colors.grey; // Use the same color mapping as cards

      return SplineSeries<ChartData, DateTime>(
        name: bankName,
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        color: seriesColor,
        width: 2,
        animationDuration: showAnimation ? 1000 : 0,
        markerSettings: MarkerSettings(
          isVisible: false,
        ),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
      );
    }).toList();
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData(this.x, this.y);
}
