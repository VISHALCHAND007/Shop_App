import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  late String _token;
  late String _userId;
  late DateTime _expiryDate;

  Future<void> signUp(String email, String password) async {
    print("$email, $password");
    var url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
    final response = await http.post(Uri.parse(url), body: json.encode( {
      "email": email,
      "password": password,
      "returnSecureToken": true
    }));
    print((json.decode(response.body)));
  }
}
