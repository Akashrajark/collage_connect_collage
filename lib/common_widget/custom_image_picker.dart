import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final bool filled, isRequired, isDateTime;
  final Function(DateTime?) onPick;
  final DateTime? selectedDate, firstDate, lastDate, initialDate;

  const CustomDatePicker({
    super.key,
    this.label = 'Select Date',
    this.filled = true,
    this.isRequired = false,
    this.isDateTime = false, // Default to date-only picker
    required this.onPick,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    if (_selectedDate != null) {
      _dateController.text = widget.isDateTime
          ? DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!)
          : DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      showCursor: false,
      readOnly: true,
      validator: widget.isRequired ? dateValidator : null,
      onTap: () async {
        if (widget.isDateTime) {
          // Date-Time Picker
          await _showDateTimePicker(context);
        } else {
          // Date-Only Picker
          await _showDatePicker(context);
        }
      },
      decoration: InputDecoration(
        hintText: widget.label,
        filled: widget.filled,
        suffixIcon: _selectedDate != null
            ? IconButton(
                onPressed: () {
                  _selectedDate = null;
                  widget.onPick(null);
                  _dateController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.clear),
              )
            : const Icon(Icons.date_range_outlined),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? tempDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      // initialDate: widget.initialDate ?? DateTime.now(),
      // firstDate: widget.firstDate ?? DateTime(1900),
      // lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (tempDate != null) {
      _selectedDate = tempDate;
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      widget.onPick(_selectedDate);
      setState(() {});
    }
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime now = widget.initialDate ?? DateTime.now();
    DateTime? tempDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (tempDate != null) {
      TimeOfDay? tempTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (tempTime != null) {
        _selectedDate = DateTime(
          tempDate.year,
          tempDate.month,
          tempDate.day,
          tempTime.hour,
          tempTime.minute,
        );
        _dateController.text =
            DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!);
        widget.onPick(_selectedDate);
        setState(() {});
      }
    }
  }
}
