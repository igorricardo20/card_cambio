import 'package:flutter/material.dart';

class Historical extends StatelessWidget {
  const Historical({super.key});

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
                    Text('Credit card usage rates over time')
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/01/2021')),
                        DataCell(Text('R\$ 100')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/02/2021')),
                        DataCell(Text('R\$ 200')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/03/2021')),
                        DataCell(Text('R\$ 300')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/04/2021')),
                        DataCell(Text('R\$ 400')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/05/2021')),
                        DataCell(Text('R\$ 500')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/06/2021')),
                        DataCell(Text('R\$ 600')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/07/2021')),
                        DataCell(Text('R\$ 700')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/08/2021')),
                        DataCell(Text('R\$ 800')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/09/2021')),
                        DataCell(Text('R\$ 900')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('01/10/2021')),
                        DataCell(Text('R\$ 1000')),
                      ],
                    ),
                  ],
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}