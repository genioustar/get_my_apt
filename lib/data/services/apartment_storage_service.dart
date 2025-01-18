import 'package:get_my_apt/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/apartment.dart';

class ApartmentStorageService {
  static const String _boxName = 'apartments';
  static late Box<Apartment> _box;

  static Future<void> init() async {
    Log.instance.i('ApartmentStorageService 초기화 시작');
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(ApartmentAdapter());
      _box = await Hive.openBox<Apartment>(_boxName);
      Log.instance.i('ApartmentStorageService 초기화 완료');
    } catch (e, stackTrace) {
      Log.instance.e('ApartmentStorageService 초기화 실패',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<void> saveApartment(Apartment apartment) async {
    try {
      await _box.put(apartment.key, apartment);
      Log.instance.i('아파트 저장 완료: ${apartment.name}');
    } catch (e, stackTrace) {
      Log.instance.e('아파트 저장 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 여러 아파트 저장
  static Future<void> saveApartments(List<Apartment> apartments) async {
    final Map<String, Apartment> apartmentMap = {
      for (var apt in apartments) apt.address: apt
    };
    await _box.putAll(apartmentMap);
  }

  // 단일 아파트 불러오기
  static Apartment? loadApartment(String address) {
    return _box.get(address);
  }

  // 모든 아파트 불러오기
  static List<Apartment> loadAllApartments() {
    return _box.values.toList();
  }

  // 아파트 삭제
  static Future<void> deleteApartment(String address) async {
    await _box.delete(address);
  }

  // 모든 데이터 삭제
  static Future<void> clearAll() async {
    await _box.clear();
  }

  // 박스 닫기
  static Future<void> close() async {
    await _box.close();
  }
}
