import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthProviderFirebase with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? _token;
  // late String _userId;
  // late DateTime _expiryDate;

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  Future<String?> getToken() async{
    return await _auth.currentUser?.getIdToken();
  }

  Future<void> signUp(String email, String password) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(response.user);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print(response.user);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async{
    await _auth.signOut();
    notifyListeners();
  }
}
