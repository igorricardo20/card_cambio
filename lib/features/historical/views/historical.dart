import 'package:card_cambio/features/home/model/rate.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:card_cambio/features/historical/widgets/calendarview.dart';

class Historical extends StatefulWidget {
  const Historical({super.key});

  @override
  State<Historical> createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  String? selectedBank = 'nubank';
  bool showCalendar = true; // New state variable

  @override
  Widget build(BuildContext context) {
    final rateProvider = Provider.of<RateProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ListView(
            cacheExtent: 1000,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Historical', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text('Credit card usage rates over time'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: Row(
                        children: [
                          Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                                child: DropdownMenu<String>(
                                  width: 124,
                                  initialSelection: 'nubank',
                                  textStyle: TextStyle(color: Colors.black, fontSize: 13),
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none,
                                    filled: false,
                                    constraints: BoxConstraints(maxHeight: 35),
                                  ),
                                  menuStyle: MenuStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.white),
                                  ),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(value: 'nubank', label: 'NuBank'),
                                    DropdownMenuEntry(value: 'itau', label: 'Itaú'),
                                    DropdownMenuEntry(value: 'c6', label: 'C6 Bank'),
                                  ],
                                  onSelected: (value) {
                                    setState(() {
                                      selectedBank = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Card(
                            elevation: 0,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(CupertinoIcons.calendar_today),
                                    color: showCalendar ? Colors.blue : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        showCalendar = true;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.square_list),
                                    color: !showCalendar ? Colors.blue : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        showCalendar = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: showCalendar
                    ? FutureBuilder<Widget>(
                        future: _buildCalendar(rateProvider.rates[selectedBank!] ?? []),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[50]!,
                              highlightColor: Colors.grey[200]!,
                              child: CalendarViewPlaceholder(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      )
                    : rateProvider.hasData
                        ? PaginatedDataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Rate')),
                            ],
                            source: RateDataSource(rateProvider.rates[selectedBank!] ?? []),
                            rowsPerPage: 8,
                          )
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[50]!,
                            highlightColor: Colors.grey[200]!,
                            child: PaginatedDataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Column 1')),
                                DataColumn(label: Text('Column 2')),
                                DataColumn(label: Text('Column 3')),
                              ],
                              source: _DataTableSourceLoading(),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _buildCalendar(List<Rate> rates) async {
    await Future.delayed(Duration(milliseconds: 250)); // Simulate delay
    return CalendarView(rates);
  }
}

class _DataTableSourceLoading extends DataTableSource {
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Container(width: 50, height: 20, color: Colors.grey)),
      DataCell(Container(width: 50, height: 20, color: Colors.grey)),
      DataCell(Container(width: 50, height: 20, color: Colors.grey)),
    ]);
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 10;

  @override
  int get selectedRowCount => 0;
}

class RateDataSource extends DataTableSource {
  final List<Rate> rates;
  
  RateDataSource(this.rates);
  
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  DataRow? getRow(int index) {
    if (index >= rates.length) return null;
    final rate = rates[index];

    return DataRow(
      cells: [
        DataCell(
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              formatter.format(DateTime.parse(rate.taxaDivulgacaoDataHora)),
              key: ValueKey('date_${rate.taxaDivulgacaoDataHora}'),
            ),
          ),
        ),
        DataCell(
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              'R\$ ${rate.taxaConversao.toStringAsFixed(4)}',
              key: ValueKey('rate_${rate.taxaDivulgacaoDataHora}_${rate.taxaConversao}'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rates.length;

  @override
  int get selectedRowCount => 0;
}