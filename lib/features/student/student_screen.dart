import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_search.dart';
import 'package:collage_connect_collage/features/student/add_student.dart';
import 'package:collage_connect_collage/features/student/student_view_detail_screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Students',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 300,
                    child: CustomSearch(
                      onSearch: (p0) {},
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                    inverse: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddStudent(),
                      );
                    },
                    label: 'Add student',
                    iconData: Icons.add,
                  )
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 500,
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: const [
                    DataColumn2(label: Text('User Id'), size: ColumnSize.L),
                    DataColumn(label: Text('Student name')),
                    DataColumn(label: Text('Reg. No.')),
                    DataColumn(label: Text('Details'), numeric: true),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text(
                        '#4656',
                      )),
                      const DataCell(Text('Joy ff')),
                      const DataCell(Text('KF45136ND')),
                      DataCell(TextButton(
                          child: const Text('View Details'), onPressed: () {})),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('#44525')),
                      const DataCell(Text('Michael Smith',
                          overflow: TextOverflow.ellipsis)),
                      const DataCell(Text('FK466445MD')),
                      DataCell(TextButton(
                          child: const Text('View Details'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentViewDetailScreen(),
                                ));
                          })),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
