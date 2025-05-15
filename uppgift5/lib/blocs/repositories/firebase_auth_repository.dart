import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  final auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => auth.authStateChanges();
  Future<UserCredential> signIn(String email, String password) async {
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<UserCredential> register(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future<void> signOut() async {
    await auth.signOut();
  }
}
