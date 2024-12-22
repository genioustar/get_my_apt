import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 체크리스트 섹션을 표시하는 위젯
class ChecklistSection extends StatelessWidget {
  final Apartment apartment;

  const ChecklistSection({
    super.key,
    required this.apartment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '체크리스트',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _buildCheckItem('전체', '25'),
              _buildCheckItem('실내', '3'),
              _buildCheckItem('친환', '0'),
              _buildCheckItem('주방', '5'),
              _buildCheckItem('거실', '3'),
              _buildCheckItem('침실', '3'),
              _buildCheckItem('화장실', '5'),
              _buildCheckItem('현관', '1'),
            ],
          ),
        ],
      ),
    );
  }

  /// 체크리스트 항목을 표시하는 위젯
  /// [label]: 카테고리 이름
  /// [count]: 해당 카테고리의 체크 항목 수
  Widget _buildCheckItem(String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 8),
          Text(
            count,
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
