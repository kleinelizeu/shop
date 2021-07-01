import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  DateTime _expiryDate;
  String _token;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(
          DateTime.now(),
        )) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD_EWPdVzxj23U7ugEFkDBfNryBlEvkYk0";
    final response = await http.post(
      url,
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody["idToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
