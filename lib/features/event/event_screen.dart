import 'package:collage_connect_collage/features/event/add_event.dart';
import 'package:collage_connect_collage/features/event/event_card.dart';
import 'package:collage_connect_collage/features/event/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

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
                    'Events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddEvent(),
                      );
                    },
                    label: 'Add Event',
                    color: Colors.white,
                    iconData: Icons.add,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                  child: Wrap(
                children: [
                  EventCard(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(),
                          ));
                    },
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
