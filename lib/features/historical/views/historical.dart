import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/features/home/service/exchangerateservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Historical extends StatefulWidget {
  const Historical({super.key});

  @override
  State<Historical> createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  late Future<List<Rate>> futureRates;

  @override
  void initState() {
    super.initState();
    futureRates = ExchangeRateService().fetchExchangeRates().then((data) => data.historicoTaxas);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Historical', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Credit card usage rates over time'),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: FutureBuilder<List<Rate>>(
                  future: futureRates,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
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
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No data available'));
                    }
                    return PaginatedDataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Rate')),
                      ],
                      source: RateDataSource(snapshot.data!),
                      rowsPerPage: 30,
                    );
                  },
                )
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
  RateDataSource(this.rates);
  final List<Rate> rates;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');


  @override
  DataRow getRow(int index) {
    final rate = rates[index];
    final formattedDate = formatter.format(DateTime.parse(rate.taxaDivulgacaoDataHora));

    return DataRow(cells: [
      DataCell(Text(formattedDate)),
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