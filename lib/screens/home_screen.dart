import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_final_appproject/screens/interview_screen.dart';
import '../data/mock_data.dart';
import 'dart:async';

// HomeScreen은 StatefulWidget으로, 상태를 관리합니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState는 HomeScreen의 상태를 관리합니다.
class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 3초마다 자동 슬라이드
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      // 현재 페이지가 마지막 페이지면 첫 페이지로 이동
      if (_pageController.page == mockJobPostings.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        // 아니라면 다음 페이지로 이동
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white30,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: SafeArea(child: Center(child: buildHeader())),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 217, 239, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('🧾 최근 채용정보'),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _pageController, // 페이지뷰 컨트롤러
                            itemCount: mockJobPostings.length,
                            itemBuilder: (context, index) {
                              final job = mockJobPostings[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.position,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(job.companyName),
                                      const SizedBox(height: 4),
                                      Text('${job.location} • ${job.salary}'),
                                      const Spacer(),
                                      Text(
                                        job.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 241, 211),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('🤝 주요 청년정책'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mockPolicies.length,
                          itemBuilder: (context, index) {
                            final policy = mockPolicies[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(policy.title),
                                subtitle: Text(
                                  '${policy.organization} • ${policy.supportAmount}',
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 251, 221, 244),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('🧑‍💻 면접 준비하기'),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI 면접 시뮬레이터',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('실제 면접처럼 AI와 대화하며 면접 준비를 해보세요.'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    //TODO: 면접 시뮬레이터로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const InterviewScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('면접 시작하기'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/beg.png', height: 120)
            .animate()
            .fade()
            .slideY(begin: -3, end: 0)
            .animate(onPlay: (controller) => controller.repeat())
            .shake(hz: 4, curve: Curves.easeInOutCubic, duration: 1800.ms),
        const SizedBox(height: 10),
        const Text(
          '청년 취업 내비게이터',
          style: TextStyle(
            fontSize: 30,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
