import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final String label;
  final bool filled;
  final bool isRequired;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?) onPick;

  const CustomTimePicker({
    super.key,
    this.label = 'Select Time',
    this.filled = true,
    this.isRequired = false,
    required this.onPick,
    this.initialTime,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay? _selectedTime;
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    if (_selectedTime != null) {
      _timeController.text = _formatTime(_selectedTime!);
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String? _validator(String? value) {
    if (widget.isRequired && (value == null || value.trim().isEmpty)) {
      return 'This field is required.';
    }
    if (value != null && value.trim().isNotEmpty) {
      if (!RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(value)) {
        return 'Please select a valid time (HH:MM)';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _timeController,
      showCursor: false,
      readOnly: true,
      validator: _validator,
      onTap: () async {
        TimeOfDay initial = _selectedTime ?? TimeOfDay.now();
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: initial,
        );
        if (picked != null) {
          _selectedTime = picked;
          _timeController.text = _formatTime(picked);
          widget.onPick(picked);
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: widget.label,
        filled: widget.filled,
        suffixIcon: _selectedTime != null
            ? IconButton(
                onPressed: () {
                  _selectedTime = null;
                  _timeController.clear();
                  widget.onPick(null);
                  setState(() {});
                },
                icon: const Icon(Icons.clear),
              )
            : const Icon(Icons.access_time_outlined),
      ),
    );
  }
}
