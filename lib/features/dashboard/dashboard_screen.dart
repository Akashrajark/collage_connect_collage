import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Wrap(
            spacing: 20,
            children: [
              DashboardItem(
                count: '462',
                label: 'Students',
                color: Color(0xFFA9E4FA),
              ),
              DashboardItem(
                count: '2',
                label: 'Canteen',
                color: Color(0xFFFFE4BC),
              ),
              DashboardItem(
                count: '5',
                label: 'Events',
                color: Color(0xFFF8BAB9),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const DashboardItem({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Text(
              count,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black text inside circle
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black, // White text
            ),
          ),
        ],
      ),
    );
  }
}
