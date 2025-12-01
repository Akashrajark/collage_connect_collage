import 'package:collage_connect_collage/features/events/events_bloc/events_bloc.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_search.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<dynamic, dynamic> eventDetails;

  const EventDetailsScreen({
    super.key,
    required this.eventDetails,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventsBloc _eventsBloc = EventsBloc();

  Map<String, dynamic> params = {
    'query': null,
    'event_id': null,
  };

  List<Map> _eventRegistrations = [];

  @override
  void initState() {
    params['event_id'] = widget.eventDetails['id'];
    getEvents();
    super.initState();
  }

  void getEvents() {
    _eventsBloc.add(GetAllEventRegistrationsEvent(params: params));
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
          } else if (state is EventRegistrationsGetSuccessState) {
            _eventRegistrations = state.eventRegistrations;
            Logger().w(_eventRegistrations);
            setState(() {});
          } else if (state is EventsSuccessState) {
            getEvents();
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: Center(
            child: SizedBox(
              width: 1000,
              child: ListView(
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
                  if (widget.eventDetails['image_url'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        widget.eventDetails['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 80),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  // Content
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            formatValue(widget.eventDetails['title']),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Description Card
                          if (widget.eventDetails['description'] != null &&
                              widget.eventDetails['description'].toString().isNotEmpty)
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
                                    formatValue(widget.eventDetails['description']),
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
                            'Event Details',
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
                                value: formatDate(widget.eventDetails['event_date']),
                                color: Colors.red,
                              ),
                              _buildDetailCard(
                                icon: Icons.access_time,
                                label: 'Time',
                                value:
                                    '${formatValue(widget.eventDetails['start_time'])} - ${formatValue(widget.eventDetails['end_time'])}',
                                color: Colors.orange,
                              ),
                              _buildDetailCard(
                                icon: Icons.location_on,
                                label: 'Venue',
                                value: formatValue(widget.eventDetails['venu']),
                                color: Colors.green,
                              ),
                              _buildDetailCard(
                                icon: Icons.person,
                                label: 'Organizer',
                                value: formatValue(widget.eventDetails['organizer_name']),
                                color: Colors.purple,
                              ),
                              _buildDetailCard(
                                icon: Icons.phone,
                                label: 'Contact',
                                value: formatValue(widget.eventDetails['phone']),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (state is EventsLoadingState)
                            const Center(child: CircularProgressIndicator())
                          else if (state is EventRegistrationsGetSuccessState && _eventRegistrations.isEmpty)
                            const Center(child: Text('No Event Registration found'))
                          else if (state is EventRegistrationsGetSuccessState && _eventRegistrations.isNotEmpty)
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
                                  _eventRegistrations.length,
                                  (index) => DataRow(cells: [
                                    DataCell(Text(
                                      formatValue(_eventRegistrations[index]['title']),
                                    )),
                                    DataCell(Text(formatDate(_eventRegistrations[index]['event_date']))),
                                    DataCell(Text(formatValue(_eventRegistrations[index]['venu']))),
                                    DataCell(Text(formatValue(_eventRegistrations[index]['organizer_name']))),
                                    DataCell(Row(
                                      children: [],
                                    )),
                                  ]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ));
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
