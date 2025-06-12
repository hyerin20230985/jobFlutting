import '../models/job_posting.dart';
import '../models/youth_policy.dart';
import '../models/interview_question.dart';

final List<JobPosting> mockJobPostings = [
  JobPosting(
    id: '1',
    companyName: '테크 컴퍼니',
    position: 'Flutter 개발자',
    location: '서울 강남구',
    description: '모바일 앱 개발 경험이 있는 Flutter 개발자를 모집합니다.',
    requirements: 'Flutter 2년 이상 경력',
    salary: '연봉 4,000만원 ~ 6,000만원',
    postedDate: DateTime.now().subtract(const Duration(days: 2)),
    category: 'IT',
  ),
  JobPosting(
    id: '2',
    companyName: '마케팅 에이전시',
    position: '디지털 마케터',
    location: '서울 서초구',
    description: 'SNS 마케팅 및 콘텐츠 제작 경험이 있는 디지털 마케터를 모집합니다.',
    requirements: '마케팅 관련 전공 또는 경력 1년 이상',
    salary: '연봉 3,500만원 ~ 4,500만원',
    postedDate: DateTime.now().subtract(const Duration(days: 1)),
    category: '마케팅',
  ),
  JobPosting(
    id: '3',
    companyName: '하이치과',
    position: '치위생사',
    location: '대전 대덕구',
    description: '임플란트 & 교정 어시스트 경험이 있고, 차트를 잘 사용하시는 치위생사를 모집합니다.',
    requirements: '관련 대학 졸업(2,3년제) 이상',
    salary: '연봉 협상',
    postedDate: DateTime.now().subtract(const Duration(days: 4)),
    category: '의료',
  ),
];

final List<YouthPolicy> mockPolicies = [
  YouthPolicy(
    id: '1',
    title: '청년 취업 지원금',
    organization: '고용지원센터',
    description: '취업 준비 중인 청년들에게 월 50만원의 지원금을 지급합니다.',
    target: '만 18-34세 미취업 청년',
    supportAmount: '월 50만원',
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 12, 31),
    location: '전국',
    category: '취업지원',
  ),
  YouthPolicy(
    id: '2',
    title: '청년 창업 지원사업',
    organization: '중소기업청',
    description: '청년 창업가를 위한 사업화 자금을 지원합니다.',
    target: '만 18-39세 예비 창업가',
    supportAmount: '최대 5,000만원',
    startDate: DateTime(2024, 3, 1),
    endDate: DateTime(2024, 8, 31),
    location: '전국',
    category: '창업지원',
  ),
  YouthPolicy(
    id: '3',
    title: '청년안심주택 공급활성화',
    organization: '건축기획관',
    description:
        '높은 주거비 부담 등에 시달리는 청년․신혼부부의 안정적인 주거환경 확보를 위해 청년안심주택 입주자에 대하여 주거비를 지원합니다.',
    target: '만 19세-39세 서울특별시 거주',
    supportAmount: '임차보증금 무이자 지원',
    startDate: DateTime(2025, 01, 01),
    endDate: DateTime(2025, 12, 31),
    location: '서울특별시',
    category: '주거지원',
  ),
];

final List<InterviewQuestion> mockQuestions = [
  InterviewQuestion(
    id: '1',
    question: '자기소개를 해주세요.',
    category: '일반',
    keywords: ['자기소개', '경력', '성장과정'],
    difficulty: '쉬움',
    industry: '전체',
  ),
  InterviewQuestion(
    id: '2',
    question: 'Flutter와 React Native의 차이점에 대해 설명해주세요.',
    category: '기술',
    keywords: ['Flutter', 'React Native', '크로스플랫폼'],
    difficulty: '중간',
    industry: 'IT',
  ),
];
