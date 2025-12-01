import 'package:collage_connect_collage/util/format_function.dart';
import 'package:flutter/material.dart';

import '../../common_widget/custom_alert_dialog.dart';

class StudentDetailDialog extends StatelessWidget {
  final Map<dynamic, dynamic> student;

  const StudentDetailDialog({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final name = student['name']?.toString() ?? '-';
    final regNo = student['reg_no']?.toString() ?? '-';
    final email = student['email']?.toString() ?? '-';
    final imageUrl = student['image_url']?.toString() ?? '';
    final id = student['id']?.toString() ?? '-';
    final courseName = student['courses']?['name']?.toString() ?? '-';
    final dob = formatDate(student['dob']);
    final gender = student['gender']?.toString() ?? '-';

    return CustomAlertDialog(
      title: 'Student Details',
      content: Flexible(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Image
            if (imageUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, size: 56, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            // Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Registration Number
            Text(
              'Reg No: $regNo',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Info Items
            _buildInfoItem('Student ID', id, Icons.perm_identity),
            const SizedBox(height: 16),
            _buildInfoItem('Email', email, Icons.email),
            const SizedBox(height: 16),
            _buildInfoItem('Registration Number', regNo, Icons.badge),
            const SizedBox(height: 16),
            _buildInfoItem('Date of Birth', dob, Icons.cake),
            const SizedBox(height: 16),
            _buildInfoItem('Gender', gender, Icons.person),
            const SizedBox(height: 16),
            _buildInfoItem('Course', courseName, Icons.school),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(left: BorderSide(color: Color(0xFF2563EB), width: 3)),
        color: const Color(0xFF2563EB).withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
