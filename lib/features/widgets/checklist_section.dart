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
                _buildCheckItem('전체', apartment.checklist['전체'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('실내', apartment.checklist['실내'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('친환', apartment.checklist['친환'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('주방', apartment.checklist['주방'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('거실', apartment.checklist['거실'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('침실', apartment.checklist['침실'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('화장실', apartment.checklist['화장실'].toString()),
                const SizedBox(width: 12),
                _buildCheckItem('현관', apartment.checklist['현관'].toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 8),
          Text(count, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
