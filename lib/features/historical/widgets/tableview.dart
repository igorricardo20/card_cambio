import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../home/model/rate.dart';

class TableView extends StatefulWidget {
  final List<Rate> rates;
  final Color highlightColor;
  final bool isDark;
  final int? initialRowsPerPage;

  const TableView({
    super.key,
    required this.rates,
    required this.highlightColor,
    required this.isDark,
    this.initialRowsPerPage,
  });

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  int? _rowsPerPage;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.initialRowsPerPage ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final headingTextStyle = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 15.5,
      color: widget.isDark ? Colors.black : Colors.black,
      letterSpacing: 0.1,
    );
    int rowsPerPage = _rowsPerPage ?? 10;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.10), width: 0.7),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Theme(
          data: Theme.of(context).copyWith(
            cardTheme: CardThemeData(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            dataTableTheme: DataTableThemeData(
              headingRowColor: WidgetStateProperty.all(Colors.white),
              headingTextStyle: headingTextStyle,
              dividerThickness: 0.5,
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) => Colors.transparent),
            ),
          ),
          child: PaginatedDataTable(
            header: null,
            rowsPerPage: rowsPerPage,
            availableRowsPerPage: const [5, 10, 20],
            onRowsPerPageChanged: (value) {
              if (value != null) {
                setState(() {
                  _rowsPerPage = value;
                });
              }
            },
            showCheckboxColumn: false,
            dataRowMinHeight: 36,
            dataRowMaxHeight: 42,
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Rate')),
            ],
            source: _RatesPaginatedDataSource(widget.rates, widget.highlightColor, widget.isDark, today),
          ),
        ),
      ),
    );
  }
}

class _RatesPaginatedDataSource extends DataTableSource {
  final List<Rate> rates;
  final Color highlightColor;
  final bool isDark;
  final DateTime today;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  _RatesPaginatedDataSource(this.rates, this.highlightColor, this.isDark, this.today);

  @override
  DataRow? getRow(int index) {
    if (index >= rates.length) return null;
    final rate = rates[index];
    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.parse(rate.taxaDivulgacaoDataHora)) == DateFormat('yyyy-MM-dd').format(today);
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (isToday) {
          return highlightColor.withOpacity(isDark ? 0.22 : 0.16);
        }
        if (states.contains(WidgetState.hovered)) {
          return isDark ? Colors.grey[800] : Colors.grey[200];
        }
        return null;
      }),
      cells: [
        DataCell(
          Text(
            formatter.format(DateTime.parse(rate.taxaDivulgacaoDataHora)),
            key: ValueKey('date_${rate.taxaDivulgacaoDataHora}'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.7,
              letterSpacing: 0.05,
              color: isDark ? Colors.grey[100] : Colors.grey[900],
            ),
          ),
        ),
        DataCell(
          Text(
            'R\$ ${rate.taxaConversao.toStringAsFixed(4)}',
            key: ValueKey('rate_${rate.taxaDivulgacaoDataHora}_${rate.taxaConversao}'),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13.7,
              color: isDark ? Colors.white : Colors.black,
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
