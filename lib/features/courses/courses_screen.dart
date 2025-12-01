import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/features/courses/courses_detail_screen.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import 'add_course.dart';
import 'courses_bloc/courses_bloc.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final CoursesBloc _coursesBloc = CoursesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _courses = [];

  @override
  void initState() {
    checkLogin(context);
    getCourses();
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetAllCoursesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CoursesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCourses();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CoursesGetSuccessState) {
            _courses = state.courses;
            Logger().w(_courses);
            setState(() {});
          } else if (state is CoursesSuccessState) {
            getCourses();
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
                              getCourses();
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
                                value: _coursesBloc,
                                child: AddCourse(),
                              ),
                            );
                          },
                          label: 'Add Course',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is CoursesLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is CoursesGetSuccessState && _courses.isEmpty)
                      const Center(child: Text('No course found'))
                    else if (state is CoursesGetSuccessState && _courses.isNotEmpty)
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
                            _courses.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(
                                formatValue(_courses[index]['name']),
                              )),
                              DataCell(Text(formatValue(_courses[index]['description']))),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _coursesBloc,
                                          child: AddCourse(
                                            courseDetails: _courses[index],
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
                                          value: _coursesBloc,
                                          child: CustomAlertDialog(
                                            title: 'Delete Course',
                                            description: 'Are you sure you want to delete this course?',
                                            secondaryButton: 'Cancel',
                                            onSecondaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primaryButton: 'Delete',
                                            onPrimaryPressed: () {
                                              _coursesBloc.add(DeleteCourseEvent(courseId: _courses[index]['id']));
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
                                          builder: (context) => CoursesDetailScreen(courseDetails: _courses[index]),
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
