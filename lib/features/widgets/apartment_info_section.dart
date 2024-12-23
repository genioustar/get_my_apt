import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 아파트 기본 정보를 표시하는 섹션 위젯
class ApartmentInfoSection extends StatelessWidget {
  /// 표시할 아파트 정보 모델
  final Apartment apartment;

  const ApartmentInfoSection({
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
          // 아파트 이름 표시
          Text(
            apartment.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // 기본 정보 행들
          _buildInfoRow('주소', apartment.address),
          _buildInfoRow('전세금', apartment.price),
          _buildInfoRow('관리비', apartment.maintenanceFee),
          _buildInfoRow('평형', apartment.size),
          _buildInfoRow('방/욕실', apartment.rooms),
          _buildInfoRow('층수', apartment.floor),
        ],
      ),
    );
  }

  /// 정보를 행으로 표시하는 헬퍼 메서드
  /// [label]: 정보의 레이블 (예: "주소", "전세금" 등)
  /// [value]: 표시할 값
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
