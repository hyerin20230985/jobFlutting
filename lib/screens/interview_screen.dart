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
  final List<String> industries = ['전체', 'IT', '금융', '제조', '서비스'];
  final List<String> difficulties = ['전체', '쉬움', '중간', '어려움'];

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

  @override
  Widget build(BuildContext context) {
    if (isSimulatorMode) {
      return _buildSimulatorMode();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('면접준비'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () {
              setState(() {
                isSimulatorMode = true;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFilterSection('카테고리', categories, selectedCategory, (
                  value,
                ) {
                  setState(() => selectedCategory = value);
                }),
                const SizedBox(height: 8),
                _buildFilterSection('산업', industries, selectedIndustry, (
                  value,
                ) {
                  setState(() => selectedIndustry = value);
                }),
                const SizedBox(height: 8),
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildChip(question.category),
                            _buildChip(question.difficulty),
                            _buildChip(question.industry),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              question.keywords.map((keyword) {
                                return Chip(
                                  label: Text(keyword),
                                  backgroundColor: Colors.grey[200],
                                  labelStyle: const TextStyle(fontSize: 12),
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
      appBar: AppBar(
        title: const Text('AI 면접 시뮬레이터'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isSimulatorMode = false;
              _conversationHistory.clear();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_conversationHistory.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.smart_toy, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      '$_selectedIndustry 산업 $_selectedPosition 포지션 면접을 시작합니다.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사용 모델: ${OpenAIService.availableModels[_selectedModel]}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _conversationHistory.add({
                          'role': 'assistant',
                          'content':
                              '안녕하세요! 저는 $_selectedIndustry 산업의 $_selectedPosition 포지션을 채용하는 면접관입니다. 자기소개를 해주세요.',
                        });
                        setState(() {});
                      },
                      child: const Text('면접 시작하기'),
                    ),
                  ],
                ),
              ),
            )
          else
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '답변을 입력하세요...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSettingsDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('면접 설정'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedModel,
                  decoration: const InputDecoration(labelText: 'AI 모델'),
                  items:
                      OpenAIService.availableModels.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedModel = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedIndustry,
                  decoration: const InputDecoration(labelText: '산업'),
                  items:
                      industries.where((i) => i != '전체').map((industry) {
                        return DropdownMenuItem(
                          value: industry,
                          child: Text(industry),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedIndustry = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _selectedPosition,
                  decoration: const InputDecoration(labelText: '포지션'),
                  onChanged: (value) {
                    setState(() => _selectedPosition = value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  Widget _buildMessageBubble(String message, {required bool isAI}) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isAI ? Colors.grey[200] : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isAI ? Colors.black : Colors.white,
            fontFamily: 'Noto Sans KR',
            fontSize: 16,
            height: 1.5,
          ),
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(option),
                      selected: selectedValue == option,
                      onSelected: (selected) {
                        if (selected) {
                          onSelected(option);
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue[100],
      labelStyle: const TextStyle(fontSize: 12),
    );
  }
}
