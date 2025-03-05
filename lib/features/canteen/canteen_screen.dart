import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_label_with_text.dart';
import 'package:collage_connect_collage/features/canteen/add_canteen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CanteenScreen extends StatelessWidget {
  const CanteenScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Canteens',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddCanteen(),
                      );
                    },
                    label: 'Add Canteen',
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
                    DataColumn2(
                        label: Text('Canteen Name'), size: ColumnSize.L),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('email')),
                    DataColumn(label: Text('Details'), numeric: true),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(
                          Text('KUDUMBASREE', overflow: TextOverflow.ellipsis)),
                      const DataCell(Text('4564966644')),
                      const DataCell(Text('kudu@gmail.com')),
                      DataCell(TextButton(
                          child: const Text('View Details'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CanteenDetails(),
                            );
                          })),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Purushaasree',
                          overflow: TextOverflow.ellipsis)),
                      const DataCell(Text('4464984659894')),
                      const DataCell(Text('puru@gmail.com')),
                      DataCell(TextButton(
                          child: const Text('View Details'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CanteenDetails(),
                            );
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

class CanteenDetails extends StatelessWidget {
  const CanteenDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Canteen Details',
      content: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithLabel(
              label: 'Canteen Name',
              text: 'malkfaf',
              alignment: CrossAxisAlignment.start,
            ),
            TextWithLabel(
              label: 'Phone',
              text: '6514498218',
              alignment: CrossAxisAlignment.start,
            ),
            TextWithLabel(
              label: 'Email',
              text: 'malkfaf@gmail.com',
              alignment: CrossAxisAlignment.start,
            )
          ],
        ),
      ),
    );
  }
}
