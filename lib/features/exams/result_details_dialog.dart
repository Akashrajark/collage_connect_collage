import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/util/format_function.dart';
import 'package:flutter/material.dart';

class ResultDetailsDialog extends StatelessWidget {
  final Map resultDetails;
  final String totalMark;
  const ResultDetailsDialog({super.key, required this.resultDetails, required this.totalMark});

  @override
  Widget build(BuildContext context) {
    final mark = resultDetails['mark']?.toString() ?? '-';
    final note = resultDetails['note']?.toString() ?? '-';
    final studentName = resultDetails['students']?['name']?.toString() ?? '-';
    final studentId = resultDetails['students']?['id']?.toString() ?? '-';
    final email = resultDetails['students']?['email']?.toString() ?? '-';
    final regNo = resultDetails['students']?['reg_no']?.toString() ?? '-';
    final dob = formatDate(resultDetails['students']?['dob']);
    final gender = resultDetails['students']?['gender']?.toString() ?? '-';
    final imageUrl = resultDetails['students']?['image_url']?.toString() ?? '';

    return CustomAlertDialog(
      title: 'Result Details',
      content: Flexible(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Mark
            _buildInfoItem('Mark', '$mark / $totalMark', Icons.grade, const Color(0xFF10B981)),
            const SizedBox(height: 16),

            // Note
            _buildInfoItem('Note', note, Icons.note, const Color(0xFFF59E0B)),
            const SizedBox(height: 24),

            // Student Details Section
            const Text(
              'Student Information',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
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

            // Student Name
            _buildInfoItem('Student Name', studentName, Icons.person, const Color(0xFF2563EB)),
            const SizedBox(height: 16),

            // Student ID
            _buildInfoItem('Student ID', studentId, Icons.perm_identity, const Color(0xFF2563EB)),
            const SizedBox(height: 16),

            // Email
            _buildInfoItem('Email', email, Icons.email, const Color(0xFF2563EB)),
            const SizedBox(height: 16),

            // Registration Number
            _buildInfoItem('Registration Number', regNo, Icons.badge, const Color(0xFF2563EB)),
            const SizedBox(height: 16),

            // Date of Birth
            _buildInfoItem('Date of Birth', dob, Icons.cake, const Color(0xFF2563EB)),
            const SizedBox(height: 16),

            // Gender
            _buildInfoItem('Gender', gender, Icons.wc, const Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 3)),
        color: color.withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
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
