import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 아파트 기본 정보를 표시하는 섹션 위젯
class ApartmentInfoSection extends StatelessWidget {
  /// 표시할 아파트 정보 모델
  final Apartment apartment;
  final bool isNewApartment;

  const ApartmentInfoSection({
    super.key,
    required this.apartment,
    this.isNewApartment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('이름', apartment.name, isNewApartment),
          _buildInfoRow('주소', apartment.address, isNewApartment),
          _buildInfoRow('가격', apartment.price, isNewApartment),
          _buildInfoRow('관리비', apartment.maintenanceFee, isNewApartment),
          _buildInfoRow('크기', apartment.size, isNewApartment),
          _buildInfoRow('방 구성', apartment.rooms, isNewApartment),
          _buildInfoRow('층수', apartment.floor, isNewApartment),
        ],
      ),
    );
  }

  /// 정보를 행으로 표시하는 헬퍼 메서드
  /// [label]: 정보의 레이블 (예: "주소", "전세금" 등)
  /// [value]: 표시할 값
  Widget _buildInfoRow(String label, String value, bool isNewApartment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isNewApartment ? Colors.grey : Colors.black,
                fontStyle: isNewApartment ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
