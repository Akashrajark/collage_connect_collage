import 'package:collage_connect_collage/features/courses/add_subjects.dart';
import 'package:collage_connect_collage/features/courses/subject_details_dialog.dart';
import 'package:collage_connect_collage/features/courses/subjects_bloc/subjects_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_search.dart';
import '../../util/format_function.dart';

class CoursesDetailScreen extends StatefulWidget {
  final Map courseDetails;
  const CoursesDetailScreen({super.key, required this.courseDetails});

  @override
  State<CoursesDetailScreen> createState() => _CoursesDetailScreenState();
}

class _CoursesDetailScreenState extends State<CoursesDetailScreen> {
  final SubjectsBloc _subjectsBloc = SubjectsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _subjects = [];

  @override
  void initState() {
    params['course_id'] = widget.courseDetails['id'];
    getSubjects();
    super.initState();
  }

  void getSubjects() {
    _subjectsBloc.add(GetAllSubjectsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _subjectsBloc,
      child: BlocConsumer<SubjectsBloc, SubjectsState>(
        listener: (context, state) {
          if (state is SubjectsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getSubjects();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is SubjectsGetSuccessState) {
            _subjects = state.subjects;
            Logger().w(_subjects);
            setState(() {});
          } else if (state is SubjectsSuccessState) {
            getSubjects();
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
                              formatValue(widget.courseDetails['name']),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Description Card
                            if (widget.courseDetails['description'] != null &&
                                widget.courseDetails['description'].toString().isNotEmpty)
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
                                      formatValue(widget.courseDetails['description']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        height: 1.6,
                                      ),
                                    ),
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
                                    'Courses',
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
                                        getSubjects();
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
                                          value: _subjectsBloc,
                                          child: AddSubject(
                                            courseId: widget.courseDetails['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    label: 'Add Subject',
                                    iconData: Icons.add,
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (state is SubjectsLoadingState)
                                const Center(child: CircularProgressIndicator())
                              else if (state is SubjectsGetSuccessState && _subjects.isEmpty)
                                const Center(child: Text('No subject found'))
                              else if (state is SubjectsGetSuccessState && _subjects.isNotEmpty)
                                Expanded(
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    columns: const [
                                      DataColumn2(label: Text('Course Name'), size: ColumnSize.L),
                                      DataColumn(label: Text('Description')),
                                      DataColumn(label: Text('Details'), numeric: true),
                                    ],
                                    rows: List.generate(
                                      _subjects.length,
                                      (index) => DataRow(cells: [
                                        DataCell(Text(
                                          formatValue(_subjects[index]['name']),
                                        )),
                                        DataCell(Text(formatValue(_subjects[index]['description']))),
                                        DataCell(Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => BlocProvider.value(
                                                    value: _subjectsBloc,
                                                    child: AddSubject(
                                                      courseId: widget.courseDetails['id'],
                                                      subjectDetails: _subjects[index],
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
                                                    value: _subjectsBloc,
                                                    child: CustomAlertDialog(
                                                      title: 'Delete Course',
                                                      description: 'Are you sure you want to delete this course?',
                                                      secondaryButton: 'Cancel',
                                                      onSecondaryPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      primaryButton: 'Delete',
                                                      onPrimaryPressed: () {
                                                        _subjectsBloc
                                                            .add(DeleteSubjectEvent(subjectId: _subjects[index]['id']));
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
                                                    builder: (context) => SubjectDetailsDialog(
                                                          subjectDetails: _subjects[index],
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
}
