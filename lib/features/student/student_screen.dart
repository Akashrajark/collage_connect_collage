import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_search.dart';
import 'package:collage_connect_collage/features/student/add_student.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../util/check_login.dart';
import 'students_bloc/students_bloc.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentsBloc _studentsBloc = StudentsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _students = [];

  @override
  void initState() {
    checkLogin(context);
    getStudents();
    super.initState();
  }

  void getStudents() {
    _studentsBloc.add(GetAllStudentsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentsBloc,
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getStudents();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is StudentsGetSuccessState) {
            _students = state.students;
            Logger().w(_students);
            setState(() {});
          } else if (state is StudentsSuccessState) {
            getStudents();
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
                            onSearch: (p0) {
                              params['query'] = p0;
                              getStudents();
                            },
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
                              builder: (context) => BlocProvider.value(
                                value: _studentsBloc,
                                child: AddStudent(),
                              ),
                            );
                          },
                          label: 'Add student',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is StudentsLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is StudentsGetSuccessState && _students.isEmpty)
                      const Center(child: Text('No students found'))
                    else if (state is StudentsGetSuccessState && _students.isNotEmpty)
                      Expanded(
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
                            rows: List.generate(
                              _students.length,
                              (index) => DataRow(cells: [
                                DataCell(Text(
                                  formatValue(_students[index]['id']),
                                )),
                                DataCell(Text(formatValue(_students[index]['name']))),
                                DataCell(Text(formatValue(_students[index]['reg_no']))),
                                DataCell(Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => BlocProvider.value(
                                            value: _studentsBloc,
                                            child: AddStudent(
                                              studentDetails: _students[index],
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
                                            value: _studentsBloc,
                                            child: CustomAlertDialog(
                                              title: 'Delete Student',
                                              description: 'Are you sure you want to delete this student?',
                                              secondaryButton: 'Cancel',
                                              onSecondaryPressed: () {
                                                Navigator.pop(context);
                                              },
                                              primaryButton: 'Delete',
                                              onPrimaryPressed: () {
                                                _studentsBloc
                                                    .add(DeleteStudentEvent(studentId: _students[index]['id']));
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
                                    TextButton(
                                      child: const Text('View Details'),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomAlertDialog(
                                            title: 'Student Details',
                                            content: Column(
                                              children: [
                                                ListTile(
                                                  leading: Image.network(
                                                    _students[index]['image_url'],
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  title: Text('Name: ${_students[index]['name']}'),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Email: ${_students[index]['email']}'),
                                                      Text('Reg. No.: ${_students[index]['reg_no']}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            primaryButton: 'Close',
                                            onPrimaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )),
                              ]),
                            )),
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
