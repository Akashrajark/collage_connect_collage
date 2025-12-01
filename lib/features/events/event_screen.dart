import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import 'add_event.dart';
import 'event_details_screen.dart';
import 'events_bloc/events_bloc.dart';

class EventScreen extends StatefulWidget {
  final String eventType;
  const EventScreen({super.key, required this.eventType});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventsBloc _eventsBloc = EventsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _events = [];

  @override
  void initState() {
    checkLogin(context);
    getEvents();
    super.initState();
  }

  void getEvents() {
    _eventsBloc.add(GetAllEventsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventsBloc,
      child: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getEvents();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is EventsGetSuccessState) {
            _events = state.events;
            Logger().w(_events);
            setState(() {});
          } else if (state is EventsSuccessState) {
            getEvents();
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
                          'Events',
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
                              getEvents();
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
                                value: _eventsBloc,
                                child: AddEvent(
                                  eventType: widget.eventType,
                                ),
                              ),
                            );
                          },
                          label: 'Add Event',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is EventsLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is EventsGetSuccessState && _events.isEmpty)
                      const Center(child: Text('No event found'))
                    else if (state is EventsGetSuccessState && _events.isNotEmpty)
                      Expanded(
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 1400,
                          columns: const [
                            DataColumn2(label: Text('Event Title'), size: ColumnSize.L),
                            DataColumn2(label: Text('Date')),
                            DataColumn2(label: Text('Venue')),
                            DataColumn2(label: Text('Organizer')),
                            DataColumn2(label: Text('Actions'), size: ColumnSize.L),
                          ],
                          rows: List.generate(
                            _events.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(
                                formatValue(_events[index]['title']),
                              )),
                              DataCell(Text(formatDate(_events[index]['event_date']))),
                              DataCell(Text(formatValue(_events[index]['venu']))),
                              DataCell(Text(formatValue(_events[index]['organizer_name']))),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _eventsBloc,
                                          child: AddEvent(
                                            eventDetails: _events[index],
                                            eventType: widget.eventType,
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
                                          value: _eventsBloc,
                                          child: CustomAlertDialog(
                                            title: 'Delete Event',
                                            description: 'Are you sure you want to delete this event?',
                                            secondaryButton: 'Cancel',
                                            onSecondaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primaryButton: 'Delete',
                                            onPrimaryPressed: () {
                                              _eventsBloc.add(DeleteEventEvent(eventId: _events[index]['id']));
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventDetailsScreen(
                                            eventDetails: _events[index],
                                          ),
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
