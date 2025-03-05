import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/features/event/add_item.dart';
import 'package:collage_connect_collage/features/event/applied_student_list.dart';
import 'package:collage_connect_collage/features/event/event_item.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            CustomButton(
              inverse: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddItem(),
                );
              },
              label: 'Add Item',
              iconData: Icons.add,
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        body: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            itemBuilder: (context, index) => EventItems(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppliedStudentList(),
                        ));
                  },
                ),
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: 10));
  }
}
