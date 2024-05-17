# Weather
> 개발기간: 2024.03 ~ 2024.04

# 프로젝트 소개
공공데이터 포털의 단기예보 조회서비스 데이터를 활용해 Tuist와 SwiftUI, Combine, TCA를 공부하기 위한 프로젝트

# 화면 구성

| 메인 화면 | 검색 화면 |
|:---:|:---:|
| <img src="https://github.com/hyeonsik971029/weather/assets/156991031/dcdf1360-c744-4d57-ade3-655eb03c49df" width="40%" height="30%" alt="main"></img> | <img src="https://github.com/hyeonsik971029/weather/assets/156991031/54540643-ef39-4a68-8514-063f1d581849" width="40%" height="30%" alt="search"></img> |

| 메인(즐겨찾기 있을 때) 화면 | 상세 화면 |
|:---:|:---:|
| <img src="https://github.com/hyeonsik971029/weather/assets/156991031/78dd24da-d079-46d9-84ac-ac16a724f99a" width="40%" height="30%" alt="favorites"></img> | <img src="https://github.com/hyeonsik971029/weather/assets/156991031/fdd63b49-fec3-4713-bc16-3c9f290b5ff8" width="40%" height="30%" alt="detail"></img> |

# 주요 기능

**메인**

 - 공공데이터 포털에서 제공하는 대한민국 지역을 표시
 - 지역 검색 기능 제공 (검색 시 즐겨찾기를 포함한 전 지역 검색 가능)
 - 즐겨찾기 기능 제공 (즐겨찾기 시 즐겨찾기 한 지역만 표시)

**상세**

 - 공공데이털 포털에서 제공하는 API로 해당 지역 날씨 표시
 - 즐겨찾기 기능 제공

# 기술 스택

**Environment**

 - Xcode version: 15.3

**Config**

 - Tuist Version: 4.9.0

**Development**

 - iOS Deployment Target: 15.0
 - TCA Version: 1.9.3

# 프로젝트 구조

![graph](https://github.com/hyeonsik971029/weather/assets/156991031/b9f5c832-72d9-4ae0-af73-2a9c6d9522dc)
