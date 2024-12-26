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
                // 카운트 값이 아님 초기 값 세팅하거나 값 가져오게 변경
                // apartment.checklist.toString()
                _buildCheckItem('전체'),
                const SizedBox(width: 12),
                _buildCheckItem('실내'),
                const SizedBox(width: 12),
                _buildCheckItem('친환'),
                const SizedBox(width: 12),
                _buildCheckItem('주방'),
                const SizedBox(width: 12),
                _buildCheckItem('거실'),
                const SizedBox(width: 12),
                _buildCheckItem('침실'),
                const SizedBox(width: 12),
                _buildCheckItem('화장실'),
                const SizedBox(width: 12),
                _buildCheckItem('현관'),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
