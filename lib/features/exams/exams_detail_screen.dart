import 'package:collage_connect_collage/features/exams/results_bloc/results_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_search.dart';
import '../../util/format_function.dart';
import 'add_result.dart';
import 'result_details_dialog.dart';

class ExamsDetailScreen extends StatefulWidget {
  final Map examDetails;
  const ExamsDetailScreen({super.key, required this.examDetails});

  @override
  State<ExamsDetailScreen> createState() => _ExamsDetailScreenState();
}

class _ExamsDetailScreenState extends State<ExamsDetailScreen> {
  final ResultsBloc _resultsBloc = ResultsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _results = [];

  @override
  void initState() {
    params['exam_id'] = widget.examDetails['id'];
    getResults();
    super.initState();
  }

  void getResults() {
    _resultsBloc.add(GetAllResultsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _resultsBloc,
      child: BlocConsumer<ResultsBloc, ResultsState>(
        listener: (context, state) {
          if (state is ResultsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getResults();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is ResultsGetSuccessState) {
            _results = state.results;
            Logger().w(_results);
            setState(() {});
          } else if (state is ResultsSuccessState) {
            getResults();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 1000,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              formatValue(widget.examDetails['type']),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Description Card
                            if (widget.examDetails['description'] != null &&
                                widget.examDetails['description'].toString().isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Text(
                                      formatValue(widget.examDetails['description']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),

                            // Details Section
                            const Text(
                              'Exam Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                _buildDetailCard(
                                  icon: Icons.calendar_today,
                                  label: 'Date',
                                  value: formatDate(widget.examDetails['date']),
                                  color: Colors.red,
                                ),
                                _buildDetailCard(
                                  icon: Icons.access_time,
                                  label: 'Time',
                                  value:
                                      '${formatTimeAmPm(widget.examDetails['start_time'])} - ${formatTimeAmPm(widget.examDetails['end_time'])}',
                                  color: Colors.orange,
                                ),
                                _buildDetailCard(
                                  icon: Icons.assignment,
                                  label: 'Total Marks',
                                  value: widget.examDetails['total_mark'].toString(),
                                  color: Colors.green,
                                ),
                                _buildDetailCard(
                                  icon: Icons.subject,
                                  label: 'Subject',
                                  value: formatValue(widget.examDetails['subjects']['name'] ?? 'N/A'),
                                  color: Colors.purple,
                                ),
                                _buildDetailCard(
                                  icon: Icons.school,
                                  label: 'Course',
                                  value: formatValue(widget.examDetails['courses']['name'] ?? 'N/A'),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 700,
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
                                    'Results',
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
                                        getResults();
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
                                          value: _resultsBloc,
                                          child: AddResult(
                                            courseId: widget.examDetails['course_id'],
                                            examId: widget.examDetails['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    label: 'Add Result',
                                    iconData: Icons.add,
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (state is ResultsLoadingState)
                                const Center(child: CircularProgressIndicator())
                              else if (state is ResultsGetSuccessState && _results.isEmpty)
                                const Center(child: Text('No result found'))
                              else if (state is ResultsGetSuccessState && _results.isNotEmpty)
                                Expanded(
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    columns: const [
                                      DataColumn2(label: Text('Student Name'), size: ColumnSize.L),
                                      DataColumn(label: Text('Mark')),
                                      DataColumn(label: Text('Details'), numeric: true),
                                    ],
                                    rows: List.generate(
                                      _results.length,
                                      (index) => DataRow(cells: [
                                        DataCell(Text(
                                          formatValue(_results[index]['students']['name']),
                                        )),
                                        DataCell(Text(
                                            '${formatValue(_results[index]['mark'])}/${formatValue(widget.examDetails['total_mark'])}')),
                                        DataCell(Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => BlocProvider.value(
                                                    value: _resultsBloc,
                                                    child: AddResult(
                                                      courseId: widget.examDetails['course_id'],
                                                      examId: widget.examDetails['id'],
                                                      resultDetails: _results[index],
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
                                                    value: _resultsBloc,
                                                    child: CustomAlertDialog(
                                                      title: 'Delete Exam',
                                                      description: 'Are you sure you want to delete this exam?',
                                                      secondaryButton: 'Cancel',
                                                      onSecondaryPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      primaryButton: 'Delete',
                                                      onPrimaryPressed: () {
                                                        _resultsBloc
                                                            .add(DeleteResultEvent(resultId: _results[index]['id']));
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
                                                    builder: (context) => ResultDetailsDialog(
                                                          resultDetails: _results[index],
                                                          totalMark: widget.examDetails['total_mark'].toString(),
                                                        ));
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

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
