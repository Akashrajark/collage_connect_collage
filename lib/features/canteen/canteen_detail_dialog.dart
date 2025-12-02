import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class CanteenDetailDialog extends StatelessWidget {
  final Map<dynamic, dynamic> canteen;

  const CanteenDetailDialog({
    super.key,
    required this.canteen,
  });

  @override
  Widget build(BuildContext context) {
    final name = canteen['name']?.toString() ?? '-';
    final phone = canteen['phone']?.toString() ?? '-';
    final email = canteen['email']?.toString() ?? '-';
    final imageUrl = canteen['image_url']?.toString() ?? '';
    final id = canteen['id']?.toString() ?? '-';
    final description = canteen['description']?.toString() ?? '-';

    return CustomAlertDialog(
      title: 'Canteen Details',
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
                  child: const Icon(Icons.restaurant, size: 56, color: Colors.grey),
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

            // ID
            Text(
              'ID: $id',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Info Items
            _buildInfoItem('Canteen ID', id, Icons.perm_identity),
            const SizedBox(height: 16),
            _buildInfoItem('Email', email, Icons.email),
            const SizedBox(height: 16),
            _buildInfoItem('Phone', phone, Icons.phone),
            const SizedBox(height: 16),
            _buildInfoItem('Description', description, Icons.description),
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
