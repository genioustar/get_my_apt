# Get My Apt

## 프로젝트 구조

```
lib/
├── core/
│ ├── constants/
│ │ └── app_constants.dart
│ └── theme/
│ └── app_theme.dart
├── data/
│ ├── models/
│ │ └── apartment.dart
│ └── repositories/
│ └── apartment_repository.dart
├── features/
│ └── apartment/
│ ├── widgets/
│ │ ├── apartment_info_section.dart
│ │ ├── evaluation_section.dart
│ │ ├── image_grid_section.dart
│ │ ├── checklist_section.dart
│ │ └── rating_chart_section.dart
│ ├── screens/
│ │ └── detail_screen.dart
│ └── providers/
│ └── apartment_provider.dart
└── main.dart
```

프로젝트는 다음과 같은 주요 디렉토리로 구성되어 있습니다:

- core/: 앱의 기본 설정과 상수들
- data/: 데이터 모델과 저장소 관련 코드
- features/: 기능별 위젯과 화면 구성요소
- main.dart: 앱의 진입점

## 주요 기능 구현

데이터 모델

- Apartment 클래스: 아파트 정보를 저장하는 Hive 모델
- 이름, 주소, 가격, 관리비 등의 기본 정보
- 체크리스트, 평가 점수 등의 상세 정보
- Hive를 사용하여 로컬 저장소에 아파트 정보를 저장

## 화면 구성

- 메인 상세 화면은 다음 섹션들로 구성:
- 아파트 기본 정보 (ApartmentInfoSection)
- 평가 섹션 (EvaluationSection)
- 이미지 그리드 (ImageGridSection)
- 체크리스트 (ChecklistSection)
- 평가 차트 (RatingChartSection)

## 상태 관리

- StatefulWidget을 사용하여 화면 상태 관리
- Hive를 통한 영구 데이터 저장
  mounted 체크를 통한 안전한 상태 업데이트

## 플랫폼 지원

- Android, iOS, Web 등 크로스 플랫폼 지원
- 플랫폼별 설정 파일들이 각각의 디렉토리에 구성

## 주요 기능 흐름

1. 앱 시작 시 Hive 초기화
2. 아파트 상세 화면 로드
3. 저장된 아파트 정보 불러오기
4. 사용자 인터랙션에 따른 데이터 업데이트
5. 변경된 정보 로컬 저장소에 저장

### 이 앱은 아파트 정보를 효율적으로 관리하고 표시하는 것에 중점을 둔 Flutter 애플리케이션입니다. Hive를 사용한 로컬 데이터 저장과 체계적인 위젯 구조를 통해 사용자 경험을 최적화하고 있습니다.
