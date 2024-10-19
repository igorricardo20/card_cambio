import 'package:card_cambio/features/home/model/rate.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Historical extends StatefulWidget {
  const Historical({super.key});

  @override
  State<Historical> createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  String? selectedBank = 'nubank';

  @override
  Widget build(BuildContext context) {
    final rateProvider = Provider.of<RateProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: ListView(
            cacheExtent: 1000,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Historical', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Credit card usage rates over time'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: Row(
                        children: [
                          Card(
                            elevation: 0,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                                child: DropdownMenu<String>(
                                  width: 124,
                                  initialSelection: 'nubank',
                                  textStyle: TextStyle(color: Colors.black, fontSize: 15),
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
                                    // DropdownMenuEntry(value: 'bradesco', label: 'Bradesco'),
                                    // DropdownMenuEntry(value: 'btg', label: 'BTG'),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: rateProvider.hasData
                    ? PaginatedDataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Rate')),
                        ],
                        source: RateDataSource(rateProvider.rates[selectedBank!] ?? []),
                        rowsPerPage: 30,
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
    return DataRow(cells: [
      DataCell(Text(formatter.format(DateTime.parse(rate.taxaDivulgacaoDataHora)))),
      DataCell(Text('R\$ ${rate.taxaConversao.toStringAsFixed(4)}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rates.length;

  @override
  int get selectedRowCount => 0;
}