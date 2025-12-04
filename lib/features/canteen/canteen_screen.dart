import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_label_with_text.dart';
import 'package:collage_connect_collage/features/canteen/add_canteen.dart';
import 'package:collage_connect_collage/features/canteen/canteen_detail_dialog.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import 'canteens_bloc/canteens_bloc.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({super.key});

  @override
  State<CanteenScreen> createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final CanteensBloc _canteensBloc = CanteensBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _canteens = [];

  @override
  void initState() {
    checkLogin(context);
    getCanteens();
    super.initState();
  }

  void getCanteens() {
    _canteensBloc.add(GetAllCanteensEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _canteensBloc,
      child: BlocConsumer<CanteensBloc, CanteensState>(
        listener: (context, state) {
          if (state is CanteensFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCanteens();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CanteensGetSuccessState) {
            _canteens = state.canteens;
            Logger().w(_canteens);
            setState(() {});
          } else if (state is CanteensSuccessState) {
            getCanteens();
          }
        },
        builder: (context, state) {
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
                          'Canteens',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 300,
                          child: CustomSearch(
                            onSearch: (p0) {
                              params['query'] = p0;
                              getCanteens();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomButton(
                          inverse: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BlocProvider.value(
                                value: _canteensBloc,
                                child: AddCanteen(),
                              ),
                            );
                          },
                          label: 'Add Canteen',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is CanteensLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is CanteensGetSuccessState && _canteens.isEmpty)
                      const Center(child: Text('No canteen found'))
                    else if (state is CanteensGetSuccessState && _canteens.isNotEmpty)
                      Expanded(
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: const [
                            DataColumn2(label: Text('Canteen Name'), size: ColumnSize.L),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('email')),
                            DataColumn(label: Text('Details'), numeric: true),
                          ],
                          rows: List.generate(
                            _canteens.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(
                                formatValue(_canteens[index]['name']),
                              )),
                              DataCell(Text(formatValue(_canteens[index]['phone']))),
                              DataCell(Text(formatValue(_canteens[index]['email']))),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _canteensBloc,
                                          child: AddCanteen(
                                            canteenDetails: _canteens[index],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _canteensBloc,
                                          child: CustomAlertDialog(
                                            title: 'Delete Canteen',
                                            description: 'Are you sure you want to delete this canteen?',
                                            secondaryButton: 'Cancel',
                                            onSecondaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primaryButton: 'Delete',
                                            onPrimaryPressed: () {
                                              _canteensBloc
                                                  .add(DeleteCanteenEvent(userId: _canteens[index]['user_id']));
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    child: const Text('View Details'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CanteenDetailDialog(
                                          canteen: _canteens[index],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )),
                            ]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
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
