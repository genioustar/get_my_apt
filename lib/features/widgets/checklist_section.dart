import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 체크리스트 섹션을 표시하는 위젯
class ChecklistSection extends StatelessWidget {
  final Apartment apartment;

  const ChecklistSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('체크리스트',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...apartment.checklist.map((category) => Row(
                      children: [
                        _buildCheckItem(category),
                        const SizedBox(width: 12),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label),
    );
  }
}
