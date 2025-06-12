import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  late final String _apiKey;

  // 지원하는 모델 목록
  static const Map<String, String> availableModels = {
    'gpt-4': 'GPT-4 (가장 자연스러운 대화)',
    'gpt-4-turbo': 'GPT-4 Turbo (빠른 응답)',
    'gpt-3.5-turbo': 'GPT-3.5 Turbo (경제적)',
  };

  OpenAIService() {
    _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  Future<String> getInterviewResponse(
    String userMessage,
    List<Map<String, String>> conversationHistory, {
    String model = 'gpt-4',
    String industry = 'IT',
    String position = '신입 개발자',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': '''
당신은 $industry 산업의 $position 포지션을 채용하는 전문 면접관입니다.
다음 가이드라인을 따라 면접을 진행해주세요:

1. 지원자의 답변에 대해 구체적이고 건설적인 피드백을 제공하세요.
2. 답변의 강점과 개선점을 함께 언급하세요.
3. 다음 질문은 이전 답변의 맥락을 고려하여 자연스럽게 이어가세요.
4. 기술적 역량과 함께 소프트 스킬(의사소통, 문제해결 등)도 평가하세요.
5. 지원자가 불편함을 느끼지 않도록 친절하고 전문적인 태도를 유지하세요.
6. 필요하다면 답변을 더 구체적으로 이끌어내는 후속 질문을 하세요.

면접은 다음 순서로 진행됩니다:
1. 자기소개
2. 지원 동기
3. 기술/전문성 관련 질문
4. 상황 대처/문제해결 능력
5. 팀워크/의사소통
6. 마무리 질문
''',
            },
            ...conversationHistory,
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'presence_penalty': 0.6,
          'frequency_penalty': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        print('Response content: $content');
        return content;
      } else {
        print('Error response: ${response.body}');
        print('Response headers: ${response.headers}');
        throw Exception('Failed to get response from OpenAI: ${response.body}');
      }
    } catch (e) {
      return '죄송합니다. 응답을 생성하는 중에 오류가 발생했습니다: $e';
    }
  }
}
