import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/models/apartment.dart';

/// 아파트 기본 정보를 표시하는 섹션 위젯
class ApartmentInfoSection extends StatelessWidget {
  final Apartment apartment;
  final bool isNewApartment;
  final Function(Apartment)? onApartmentUpdated;

  const ApartmentInfoSection({
    super.key,
    required this.apartment,
    this.isNewApartment = false,
    this.onApartmentUpdated,
  });

  bool get _hasData => apartment.name.isNotEmpty;

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            final nameController = TextEditingController();
            final dongController = TextEditingController();
            final hoController = TextEditingController();
            final priceController = TextEditingController();
            final maintenanceFeeController = TextEditingController();
            final sizeM2Controller = TextEditingController();
            final sizePyeongController = TextEditingController();
            final roomCountController = TextEditingController();
            final bathroomCountController = TextEditingController();
            String contractType = '매매';

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '주소를 등록해주세요',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text('매물이름'),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: '은마아파트',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('동 (선택)'),
                                      TextField(
                                        controller: dongController,
                                        decoration: InputDecoration(
                                          hintText: '동 입력',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('호수 (선택)'),
                                      TextField(
                                        controller: hoController,
                                        decoration: InputDecoration(
                                          hintText: '호수 입력',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('계약형태'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => contractType = '매매',
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: contractType == '매매'
                                          ? Colors.blue
                                          : Colors.grey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Text('매매'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildPriceField(
                                '매매가 (선택)', '금액입력', '만원', priceController),
                            const SizedBox(height: 8),
                            buildPriceField('관리비 (선택)', '금액입력', '만원',
                                maintenanceFeeController),
                            const SizedBox(height: 16),
                            const Text('면적 (선택)'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: sizeM2Controller,
                                    decoration: InputDecoration(
                                      hintText: '면적 입력',
                                      suffixText: 'm²',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child:
                                      Icon(Icons.sync_alt, color: Colors.grey),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: sizePyeongController,
                                    decoration: InputDecoration(
                                      hintText: '면적 입력',
                                      suffixText: '평',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('방 개수 (선택)'),
                                      TextField(
                                        controller: roomCountController,
                                        decoration: InputDecoration(
                                          hintText: '방 개수',
                                          suffixText: '개',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('화장실 개수 (선택)'),
                                      TextField(
                                        controller: bathroomCountController,
                                        decoration: InputDecoration(
                                          hintText: '화장실 개수',
                                          suffixText: '개',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final newApartment = Apartment(
                            name: nameController.text.isEmpty
                                ? '${DateTime.now().toString().substring(0, 16)} 등록매물'
                                : nameController.text,
                            address:
                                '${dongController.text}동 ${hoController.text}호',
                            price: priceController.text,
                            maintenanceFee: maintenanceFeeController.text,
                            size:
                                '${sizeM2Controller.text}m² (${sizePyeongController.text}평)',
                            rooms:
                                '${roomCountController.text}개, 화장실 ${bathroomCountController.text}개',
                            floor: '',
                            rating: 0.0,
                            description: '',
                            images: [],
                            checklist: [],
                            ratings: {},
                            ratingCounts: {},
                            evaluationAnswers: apartment.evaluationAnswers,
                          );

                          try {
                            final box =
                                await Hive.openBox<Apartment>('apartments');
                            await box.put(
                                newApartment.storageKey, newApartment);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('매물 정보가 저장되었습니다')),
                              );
                              Navigator.pop(context);

                              onApartmentUpdated?.call(newApartment);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _showRegistrationDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              '매물정보등록',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    // 기존 데이터 표시 로직
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('이름', apartment.name),
          _buildInfoRow('주소', apartment.address),
          _buildInfoRow('가격', apartment.price),
          _buildInfoRow('관리비', apartment.maintenanceFee),
          _buildInfoRow('크기', apartment.size),
          _buildInfoRow('방 구성', apartment.rooms),
          _buildInfoRow('층수', apartment.floor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget buildPriceField(String label, String hint, String suffix,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
