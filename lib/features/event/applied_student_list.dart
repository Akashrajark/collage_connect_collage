import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppliedStudentList extends StatelessWidget {
  const AppliedStudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                columns: const [
                  DataColumn2(label: Text('Student Name'), size: ColumnSize.L),
                  DataColumn(label: Text('Item name')),
                  DataColumn(label: Text('Reg. No.'), numeric: true),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Joy ff')),
                    const DataCell(Text('100 mtr')),
                    const DataCell(Text('FK466445MD')),
                  ]),
                  DataRow(cells: [
                    const DataCell(
                        Text('Michael Smith', overflow: TextOverflow.ellipsis)),
                    const DataCell(Text('100 mtr')),
                    const DataCell(Text('FK466445MD')),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
