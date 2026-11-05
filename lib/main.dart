import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:retro_arcade_defender/services/auth_service.dart';
import 'screens/menu_screen.dart';
import 'screens/login_screen.dart';
import 'screens/test_button_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
  } catch (e) {
    print('Firebase initialization failed: $e');
    firebaseInitialized = false;
  }

  // Initialize FlameAudio cache for background music
  await FlameAudio.audioCache.load('background.mp3');

  // Start background music immediately when app starts
  FlameAudio.bgm.play('background.mp3', volume: 0.8);

  runApp(MyApp(firebaseInitialized: firebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;

  const MyApp({super.key, required this.firebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Arcade Defender',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(firebaseInitialized: firebaseInitialized),
    );
  }
}


class AuthWrapper extends StatefulWidget {
  final bool firebaseInitialized;

  const AuthWrapper({super.key, required this.firebaseInitialized});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late final AuthService _authService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Only initialize AuthService if Firebase is available
    if (widget.firebaseInitialized) {
      _authService = AuthService();
    }
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Pequeno delay para simular verificação
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If Firebase is not initialized, go directly to menu
    if (!widget.firebaseInitialized) {
      return const MenuScreen();
    }

    // Verificar se o usuário está logado
    if (_authService.isUserLoggedIn()) {
      return const MenuScreen();
    } else {
      return const LoginScreen();
    }
  }
}

