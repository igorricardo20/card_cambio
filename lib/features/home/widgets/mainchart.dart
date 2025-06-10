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
        // Chart with custom tooltip overlay
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              SfCartesianChart(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                plotAreaBorderWidth: 0,
                backgroundColor: Colors.transparent,
                primaryXAxis: DateTimeAxis(
                  isVisible: false,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  dateFormat: DateFormat.MMMd(AppLocalizations.of(context)!.localeName),
                  intervalType: DateTimeIntervalType.auto,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  maximumLabels: 0,
                  labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                  tickPosition: TickPosition.inside,
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: true,
                  opposedPosition: true,
                  numberFormat: NumberFormat.currency(
                    symbol: 'R\$ ',
                    decimalDigits: 2,
                  ),
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: MajorGridLines(color: Theme.of(context).dividerColor.withOpacity(0.08), width: 0),
                  minorGridLines: const MinorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  interval: null,
                  maximumLabels: 2,
                  labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                  minimum: _getMinY(widget.rates),
                  maximum: _getMaxY(widget.rates),
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    final min = _getMinY(widget.rates);
                    final max = _getMaxY(widget.rates);
                    if (min == null || max == null) {
                      return ChartAxisLabel('', const TextStyle(fontSize: 10, color: Colors.grey));
                    }
                    if ((details.value - min).abs() < 1e-6) {
                      return ChartAxisLabel(
                        NumberFormat.currency(symbol: 'R\$ ', decimalDigits: 2).format(min),
                        const TextStyle(fontSize: 10, color: Colors.grey),
                      );
                    }
                    if ((details.value - max).abs() < 1e-6) {
                      return ChartAxisLabel(
                        NumberFormat.currency(symbol: 'R\$ ', decimalDigits: 2).format(max),
                        const TextStyle(fontSize: 10, color: Colors.grey),
                      );
                    }
                    return ChartAxisLabel('', const TextStyle(fontSize: 10, color: Colors.grey));
                  },
                ),
                onActualRangeChanged: (ActualRangeChangedArgs args) {
                  if (args.orientation == AxisOrientation.vertical) {
                    double min = args.actualMin is num ? args.actualMin.toDouble() : 0;
                    double max = args.actualMax is num ? args.actualMax.toDouble() : 0;
                    double range = max - min;
                    if (range > 0) {
                      double interval = (range / 2).clamp(0.01, double.infinity);
                      args.visibleInterval = interval;
                      if (max % interval != 0) {
                        args.visibleMax = max + (interval - (max % interval));
                      }
                    }
                  }
                },
                legend: Legend(
                  isVisible: false,
                  position: LegendPosition.top,
                  overflowMode: LegendItemOverflowMode.scroll,
                  iconHeight: 10,
                  iconWidth: 10,
                  textStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                  borderWidth: 0,
                  backgroundColor: Colors.transparent,
                  itemPadding: 20,
                ),
                series: _getSeries(widget.rates),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  canShowMarker: false,
                  header: '',
                  format: 'point.x : point.y',
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
                  textStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  borderColor: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  borderWidth: 1.2,
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.10),
                  animationDuration: 200,
                  opacity: 0.98,
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  activationMode: ActivationMode.singleTap,
                  markerSettings: const TrackballMarkerSettings(
                    markerVisibility: TrackballVisibilityMode.hidden,
                  ),
                  lineType: TrackballLineType.vertical,
                  lineColor: Theme.of(context).colorScheme.primary,
                  lineWidth: 2,
                ),
              ),
            ],
          ),
        ),
        // Toggle Slider Card and Compare Button (side by side)
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Toggle slider card with animated selection pill
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final options = [
                      {'label': AppLocalizations.of(context)!.period_1, 'days': 16},
                      {'label': AppLocalizations.of(context)!.period_2, 'days': 30},
                      {'label': AppLocalizations.of(context)!.max, 'days': 60},
                    ];
                    final optionCount = options.length;
                    final totalWidth = constraints.maxWidth;
                    final optionWidth = totalWidth / optionCount;
                    final pillWidth = optionWidth * 0.88; // Make pill a bit bigger than before
                    final pillLeft = options.indexWhere((o) => o['days'] == selectedDays) * optionWidth + (optionWidth - pillWidth) / 2;
                    return Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.08)
                                : Colors.grey.withOpacity(0.10),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Animated selection pill
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeInOut,
                            left: pillLeft,
                            top: 4,
                            bottom: 4,
                            width: pillWidth,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          // Toggle options
                          Row(
                            children: [
                              for (int i = 0; i < options.length; i++)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedDays != options[i]['days']) {
                                        setState(() {
                                          selectedDays = options[i]['days'] as int;
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        options[i]['label'] as String,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: selectedDays == options[i]['days']
                                              ? (Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Compare button (now outside the card, at its side)
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 2),
                child: Material(
                  color: Theme.of(context).cardColor,
                  shape: const CircleBorder(),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.10),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        // TODO: Implement compare action
                      },
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: Icon(
                            Icons.compare_arrows,
                            color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[200] // Lighter grey in dark mode
                                    : Colors.grey[900]), // Darker grey (not black) in light mode
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
        width: 2.5, // Slightly thicker lines
        animationDuration: showAnimation ? 1000 : 0,
        markerSettings: MarkerSettings(
          isVisible: false,
        ),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
      );
    }).toList();
  }

  double? _getMinY(Map<String, List<Rate>> rates) {
    final now = DateTime.now();
    final rangeStart = now.subtract(Duration(days: selectedDays));
    final rangeEnd = now.subtract(const Duration(days: 1));
    double? min;
    for (final entry in rates.entries) {
      for (final rate in entry.value) {
        final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
        if (rate.taxaConversao == 0) continue;
        if (dateTime.isAfter(rangeStart) && dateTime.isBefore(rangeEnd)) {
          if (min == null || rate.taxaConversao < min) min = rate.taxaConversao;
        }
      }
    }
    return min;
  }
  double? _getMaxY(Map<String, List<Rate>> rates) {
    final now = DateTime.now();
    final rangeStart = now.subtract(Duration(days: selectedDays));
    final rangeEnd = now.subtract(const Duration(days: 1));
    double? max;
    for (final entry in rates.entries) {
      for (final rate in entry.value) {
        final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
        if (rate.taxaConversao == 0) continue;
        if (dateTime.isAfter(rangeStart) && dateTime.isBefore(rangeEnd)) {
          if (max == null || rate.taxaConversao > max) max = rate.taxaConversao;
        }
      }
    }
    return max;
  }

  Widget _buildToggleSlider(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Slider card (Expanded to take available width)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10), // More space above
            child: Container(
              height: 36, // Smaller height
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.10),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Toggle options
                  for (final option in [
                    {'label': AppLocalizations.of(context)!.period_1, 'days': 16},
                    {'label': AppLocalizations.of(context)!.period_2, 'days': 30},
                    {'label': AppLocalizations.of(context)!.max, 'days': 60},
                  ])
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedDays != option['days']) {
                            setState(() {
                              selectedDays = option['days'] as int;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                          decoration: BoxDecoration(
                            color: selectedDays == option['days']
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[200] // Lighter grey in dark mode
                                    : Colors.grey[900]) // Darker grey (not black) in light mode
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            option['label'] as String,
                            style: TextStyle(
                              fontSize: 13.0, // Smaller font size
                              color: selectedDays == option['days']
                                  ? (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.black
                                      : Colors.white)
                                  : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData(this.x, this.y);
}
