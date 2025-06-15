import 'package:flutter/material.dart';
import 'package:flutter_final_appproject/screens/home_screen.dart'; // 실제 HomeScreen 경로
import 'package:flutter_final_appproject/main.dart'; // MainScreen import 추가
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 패키지 import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 인스턴스

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('로그인 실패', '이메일과 비밀번호를 모두 입력해주세요.', Colors.red);
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        _showMessage('로그인 성공', '환영합니다!', Colors.green);
        // 로그인 성공 시 MainScreen으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          message = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'user-disabled':
          message = '비활성화된 계정입니다.';
          break;
        default:
          message = e.message ?? '알 수 없는 오류가 발생했습니다.';
      }
      if (mounted) {
        _showMessage('로그인 실패', message, Colors.red);
      }
    } catch (e) {
      if (mounted) {
        _showMessage('오류', '로그인 중 오류가 발생했습니다.', Colors.red);
      }
    }
  }

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('회원가입 실패', '이메일과 비밀번호를 모두 입력해주세요.', Colors.red);
      return;
    }

    if (password.length < 6) {
      _showMessage('회원가입 실패', '비밀번호는 6자 이상이어야 합니다.', Colors.red);
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        _showMessage('회원가입 성공', '환영합니다! 이제 로그인해주세요.', Colors.green);
        // 회원가입 성공 시 입력 필드 초기화
        _emailController.clear();
        _passwordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'weak-password':
          message = '비밀번호가 너무 약합니다.';
          break;
        case 'email-already-in-use':
          message = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          message = '유효하지 않은 이메일 형식입니다.';
          break;
        default:
          message = e.message ?? '알 수 없는 오류가 발생했습니다.';
      }
      if (mounted) {
        _showMessage('회원가입 실패', message, Colors.red);
      }
    } catch (e) {
      if (mounted) {
        _showMessage('오류', '회원가입 중 오류가 발생했습니다.', Colors.red);
      }
    }
  }

  void _showMessage(String title, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.lock, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // 버튼 너비를 최대로
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _register, // 회원가입 버튼 클릭 시 _register 함수 호출
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
