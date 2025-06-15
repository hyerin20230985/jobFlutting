import 'package:flutter/material.dart';
//import '../models/interview_question.dart';
import '../data/mock_data.dart';
import '../services/openai_service.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String selectedCategory = '전체';
  String selectedIndustry = '전체';
  String selectedDifficulty = '전체';
  bool isSimulatorMode = false;

  // 면접 시뮬레이터 관련 상태
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _conversationHistory = [];
  final OpenAIService _openAIService = OpenAIService();
  String _selectedModel = 'gpt-4';
  String _selectedIndustry = 'IT';
  String _selectedPosition = '신입 개발자';
  bool _isLoading = false;

  final List<String> categories = ['전체', '일반', '기술', '인성', '경력'];
  final List<String> industries = [
    '전체',
    'IT',
    '금융',
    '제조',
    '서비스',
    '유통',
    '교육',
    '의료',
    '미디어',
    '공공',
  ];
  final List<String> difficulties = ['전체', '쉬움', '중간', '어려움'];

  // 직군 목록 추가
  final Map<String, List<String>> positionsByIndustry = {
    'IT': [
      '신입 개발자',
      '시니어 개발자',
      '프론트엔드 개발자',
      '백엔드 개발자',
      '모바일 개발자',
      '데이터 엔지니어',
      'AI 엔지니어',
      '보안 엔지니어',
      'QA 엔지니어',
      'DevOps 엔지니어',
    ],
    '금융': ['은행원', '증권사 직원', '보험 설계사', '투자 분석가', '자산운용가', '금융상담사', '회계사', '세무사'],
    '제조': ['생산관리', '품질관리', '설계 엔지니어', '연구원', '기술영업', '구매관리'],
    '서비스': ['고객상담', '영업직', '마케팅', '브랜드 매니저', '서비스 기획자', '매장 관리자'],
    '유통': ['MD', '유통관리', '물류관리', '매장 운영', '구매관리', '영업관리'],
    '교육': ['교사', '강사', '교육 컨설턴트', '교육 기획자', '학원 운영자'],
    '의료': ['의사', '간호사', '약사', '의료기기 영업', '병원 행정직'],
    '미디어': ['기자', 'PD', '작가', '편집자', '광고기획자', '콘텐츠 제작자'],
    '공공': ['공무원', '공공기관 직원', '연구원', '정책기획자'],
  };

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _conversationHistory.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });

    try {
      final response = await _openAIService.getInterviewResponse(
        userMessage,
        _conversationHistory,
        model: _selectedModel,
        industry: _selectedIndustry,
        position: _selectedPosition,
      );

      setState(() {
        _conversationHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
      }
    }
  }

  Future<void> _showInterviewSettingsDialog() async {
    String selectedIndustry = _selectedIndustry;
    String selectedPosition = _selectedPosition;
    List<String> availablePositions =
        positionsByIndustry[selectedIndustry] ?? [];

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('면접 설정'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '산업군 선택',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedIndustry,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items:
                                industries.where((i) => i != '전체').map((
                                  industry,
                                ) {
                                  return DropdownMenuItem(
                                    value: industry,
                                    child: Text(industry),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedIndustry = value;
                                  selectedPosition =
                                      positionsByIndustry[value]?.first ?? '';
                                  availablePositions =
                                      positionsByIndustry[value] ?? [];
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '직군 선택',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedPosition,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items:
                                availablePositions.map((position) {
                                  return DropdownMenuItem(
                                    value: position,
                                    child: Text(position),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedPosition = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndustry = selectedIndustry;
                          _selectedPosition = selectedPosition;
                        });
                        Navigator.pop(context);
                        _startInterview();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('면접 시작하기'),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _startInterview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _openAIService.getInterviewResponse(
        "안녕하세요, $_selectedIndustry 산업의 $_selectedPosition 포지션 면접을 시작하겠습니다.",
        [],
        industry: _selectedIndustry,
        position: _selectedPosition,
      );

      setState(() {
        _conversationHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSimulatorMode) {
      return _buildSimulatorMode();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('면접준비'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(Icons.smart_toy, color: Colors.blue.shade700),
              onPressed: () {
                setState(() {
                  isSimulatorMode = true;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildFilterSection('카테고리', categories, selectedCategory, (
                  value,
                ) {
                  setState(() => selectedCategory = value);
                }),
                const SizedBox(height: 12),
                _buildFilterSection('산업', industries, selectedIndustry, (
                  value,
                ) {
                  setState(() => selectedIndustry = value);
                }),
                const SizedBox(height: 12),
                _buildFilterSection('난이도', difficulties, selectedDifficulty, (
                  value,
                ) {
                  setState(() => selectedDifficulty = value);
                }),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockQuestions.length,
              itemBuilder: (context, index) {
                final question = mockQuestions[index];
                if ((selectedCategory != '전체' &&
                        question.category != selectedCategory) ||
                    (selectedIndustry != '전체' &&
                        question.industry != selectedIndustry) ||
                    (selectedDifficulty != '전체' &&
                        question.difficulty != selectedDifficulty)) {
                  return const SizedBox.shrink();
                }
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                question.question,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Colors.blue.shade300,
                              ),
                              onPressed: () {
                                // TODO: 북마크 기능 구현
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCategoryChip(question.category),
                            _buildDifficultyChip(question.difficulty),
                            _buildIndustryChip(question.industry),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              question.keywords.map((keyword) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    keyword,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorMode() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('AI 면접 시뮬레이터'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isSimulatorMode = false;
              _conversationHistory.clear();
              _messageController.clear();
              _isLoading = false;
            });
          },
        ),
      ),
      body:
          _conversationHistory.isEmpty
              ? Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.smart_toy,
                          size: 48,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'AI 면접 시뮬레이터',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'AI 면접관과 함께 실전 면접을 연습해보세요.\n답변을 입력하면 AI가 피드백을 제공합니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _showInterviewSettingsDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '면접 시작하기',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.play_arrow_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _conversationHistory.length,
                      itemBuilder: (context, index) {
                        final message = _conversationHistory[index];
                        return _buildMessageBubble(
                          message['content']!,
                          isAI: message['role'] == 'assistant',
                        );
                      },
                    ),
                  ),
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'AI가 답변을 분석중입니다...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!_isLoading) _buildAnswerInput(),
                ],
              ),
    );
  }

  Widget _buildMessageBubble(String message, {required bool isAI}) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          bottom: 16,
          left: isAI ? 0 : 32,
          right: isAI ? 32 : 0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAI ? Colors.white : Colors.blue.shade700,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isAI ? 0 : 20),
            bottomRight: Radius.circular(isAI ? 20 : 0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAI)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI 면접관',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              message,
              style: TextStyle(
                color: isAI ? Colors.black87 : Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit_note,
                  color: Colors.green.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '답변 작성',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '답변을 입력하세요...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _messageController.text = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _messageController.text.trim().isEmpty
                      ? null
                      : () {
                        _sendMessage();
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                '답변 제출하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String label) {
    Color color;
    switch (label) {
      case '쉬움':
        color = Colors.green;
        break;
      case '중간':
        color = Colors.orange;
        break;
      case '어려움':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIndustryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.purple.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                options.map((option) {
                  final isSelected = selectedValue == option;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          onSelected(option);
                        }
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: Colors.blue.shade100,
                      checkmarkColor: Colors.blue.shade700,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Colors.blue.shade700
                                : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Colors.blue.shade200
                                  : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
