import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_image_picker_button.dart';
import '../../common_widget/custom_date_picker.dart';
import '../../common_widget/custom_time_picker.dart';
import 'events_bloc/events_bloc.dart';

class AddEvent extends StatefulWidget {
  final Map? eventDetails;
  final String eventType;
  final String title;
  const AddEvent({
    super.key,
    this.eventDetails,
    required this.eventType,
    required this.title,
  });

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // Date/time controllers removed — using typed variables below
  final _venueController = TextEditingController();
  final _organizerNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage;
  DateTime? _selectedEventDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  @override
  void initState() {
    if (widget.eventDetails != null) {
      _titleController.text = widget.eventDetails!['title'] ?? '';
      _descriptionController.text = widget.eventDetails!['description'] ?? '';
      final evDate = widget.eventDetails!['event_date'];
      if (evDate != null) {
        // try ISO parse first, fallback to dd/MM/yyyy and plain date
        DateTime? parsed;
        try {
          parsed = DateTime.tryParse(evDate.toString());
        } catch (_) {
          parsed = null;
        }
        if (parsed == null) {
          try {
            parsed = DateFormat('dd/MM/yyyy').parseLoose(evDate.toString());
          } catch (_) {
            parsed = null;
          }
        }
        _selectedEventDate = parsed;
      }

      final sTime = widget.eventDetails!['start_time'];
      if (sTime != null) {
        final parts = sTime.toString().split(':');
        if (parts.length >= 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          _selectedStartTime = TimeOfDay(hour: h, minute: m);
        }
      }

      final eTime = widget.eventDetails!['end_time'];
      if (eTime != null) {
        final parts = eTime.toString().split(':');
        if (parts.length >= 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          _selectedEndTime = TimeOfDay(hour: h, minute: m);
        }
      }
      _venueController.text = widget.eventDetails!['venu'] ?? '';
      _organizerNameController.text = widget.eventDetails!['organizer_name'] ?? '';
      _phoneController.text = widget.eventDetails!['phone'] ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _organizerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventsSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.eventDetails == null ? 'Add ${widget.title}' : 'Edit ${widget.title}',
          isLoading: state is EventsLoadingState,
          content: Flexible(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomImagePickerButton(
                    width: double.infinity,
                    height: 200,
                    selectedImage: widget.eventDetails?['image_url'],
                    onPick: (pick) {
                      coverImage = pick;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Title', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      labelText: 'Enter title',
                      controller: _titleController,
                      validator: notEmptyValidator,
                      isLoading: false),
                  const SizedBox(height: 10),
                  const Text('Description',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      labelText: 'Enter description',
                      controller: _descriptionController,
                      validator: notEmptyValidator,
                      isLoading: false),
                  const SizedBox(height: 10),
                  const Text('Date',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomDatePicker(
                    label: 'Select date',
                    isRequired: true,
                    selectedDate: _selectedEventDate,
                    onPick: (dt) {
                      if (dt != null) {
                        _selectedEventDate = dt;
                      } else {
                        _selectedEventDate = null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Start Time',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTimePicker(
                    label: 'Select start time',
                    isRequired: true,
                    initialTime: _selectedStartTime,
                    onPick: (t) {
                      if (t != null) {
                        _selectedStartTime = t;
                      } else {
                        _selectedStartTime = null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('End Time',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTimePicker(
                    label: 'Select end time',
                    isRequired: true,
                    initialTime: _selectedEndTime,
                    onPick: (t) {
                      if (t != null) {
                        _selectedEndTime = t;
                      } else {
                        _selectedEndTime = null;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Venue',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      labelText: 'Enter venue',
                      controller: _venueController,
                      validator: notEmptyValidator,
                      isLoading: false),
                  const SizedBox(height: 10),
                  const Text('Organizer Name',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      labelText: 'Enter organizer name',
                      controller: _organizerNameController,
                      validator: notEmptyValidator,
                      isLoading: false),
                  const SizedBox(height: 10),
                  const Text('Phone Number',
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16.0)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      labelText: 'Enter phone number',
                      controller: _phoneController,
                      validator: notEmptyValidator,
                      isLoading: false),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          primaryButton: 'save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() && ((coverImage != null) || widget.eventDetails != null)) {
              Map<String, dynamic> details = {
                'title': _titleController.text.trim(),
                'description': _descriptionController.text.trim(),
                'event_date': _selectedEventDate != null ? DateFormat('yyyy-MM-dd').format(_selectedEventDate!) : '',
                'start_time': _selectedStartTime != null
                    ? '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}'
                    : '',
                'end_time': _selectedEndTime != null
                    ? '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}'
                    : '',
                'venu': _venueController.text.trim(),
                'organizer_name': _organizerNameController.text.trim(),
                'type': widget.eventType,
                'phone': _phoneController.text.trim(),
              };
              if (coverImage != null) {
                details['image'] = coverImage!.bytes;
                details['image_name'] = coverImage!.name;
              } else if (widget.eventDetails != null && widget.eventDetails!['image_url'] != null) {
                details['image_url'] = widget.eventDetails!['image_url'];
              }

              if (widget.eventDetails != null) {
                BlocProvider.of<EventsBloc>(context).add(
                  EditEventEvent(
                    eventId: widget.eventDetails!['id'],
                    eventDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<EventsBloc>(context).add(
                  AddEventEvent(
                    eventDetails: details,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
