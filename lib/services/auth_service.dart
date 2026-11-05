import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  bool _isFirebaseAvailable = false;

  AuthService() {
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _googleSignIn = GoogleSignIn();
        _isFirebaseAvailable = true;
      }
    } catch (e) {
      _isFirebaseAvailable = false;
    }
  }

  // Stream para ouvir mudanças no estado de autenticação
  Stream<User?> get authStateChanges {
    if (!_isFirebaseAvailable || _auth == null) return Stream.value(null);
    return _auth!.authStateChanges();
  }

  // Getter para o usuário atual
  User? get currentUser {
    if (!_isFirebaseAvailable || _auth == null) return null;
    return _auth!.currentUser;
  }

  // Método para fazer login com Google
  Future<UserCredential?> signInWithGoogle() async {
    if (!_isFirebaseAvailable || _auth == null || _googleSignIn == null) {
      print('Firebase not available for Google Sign-In');
      return null;
    }

    try {
      // Iniciar o processo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        // Usuário cancelou o login
        return null;
      }

      // Obter os detalhes de autenticação da conta do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Criar uma credencial do Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase com a credencial
      final UserCredential userCredential = await _auth!.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      print('Erro ao fazer login com Google: $e');
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    if (!_isFirebaseAvailable || _auth == null || _googleSignIn == null) {
      return;
    }

    try {
      await _googleSignIn!.signOut();
      await _auth!.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  // Método para verificar se o usuário está logado
  bool isUserLoggedIn() {
    if (!_isFirebaseAvailable || _auth == null) return false;
    return _auth!.currentUser != null;
  }

  // Método para obter o nome de exibição do usuário
  String? getUserDisplayName() {
    if (!_isFirebaseAvailable || _auth == null) return null;
    return _auth!.currentUser?.displayName;
  }

  // Método para obter o email do usuário
  String? getUserEmail() {
    if (!_isFirebaseAvailable || _auth == null) return null;
    return _auth!.currentUser?.email;
  }

  // Método para obter a URL da foto do usuário
  String? getUserPhotoUrl() {
    if (!_isFirebaseAvailable || _auth == null) return null;
    return _auth!.currentUser?.photoURL;
  }
}
