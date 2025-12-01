import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/features/exams/exams_detail_screen.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import 'add_exam.dart';
import 'exams_bloc/exams_bloc.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamsBloc _examsBloc = ExamsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _exams = [];

  @override
  void initState() {
    checkLogin(context);
    getExams();
    super.initState();
  }

  void getExams() {
    _examsBloc.add(GetAllExamsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _examsBloc,
      child: BlocConsumer<ExamsBloc, ExamsState>(
        listener: (context, state) {
          if (state is ExamsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getExams();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is ExamsGetSuccessState) {
            _exams = state.exams;
            Logger().w(_exams);
            setState(() {});
          } else if (state is ExamsSuccessState) {
            getExams();
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
                          'Exams',
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
                              getExams();
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
                                value: _examsBloc,
                                child: AddExam(),
                              ),
                            );
                          },
                          label: 'Add Exam',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is ExamsLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is ExamsGetSuccessState && _exams.isEmpty)
                      const Center(child: Text('No exam found'))
                    else if (state is ExamsGetSuccessState && _exams.isNotEmpty)
                      Expanded(
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: const [
                            DataColumn2(label: Text('Exam Type'), size: ColumnSize.L),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Details'), numeric: true),
                          ],
                          rows: List.generate(
                            _exams.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(
                                formatValue(_exams[index]['type']),
                              )),
                              DataCell(Text(formatValue(_exams[index]['description']))),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _examsBloc,
                                          child: AddExam(
                                            examDetails: _exams[index],
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
                                          value: _examsBloc,
                                          child: CustomAlertDialog(
                                            title: 'Delete Exam',
                                            description: 'Are you sure you want to delete this exam?',
                                            secondaryButton: 'Cancel',
                                            onSecondaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primaryButton: 'Delete',
                                            onPrimaryPressed: () {
                                              _examsBloc.add(DeleteExamEvent(examId: _exams[index]['id']));
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
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ExamsDetailScreen(examDetails: _exams[index]),
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
