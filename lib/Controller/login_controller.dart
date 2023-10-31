import 'package:unishop/Model/Repository/users_repository.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class LoginController {
  Future<Response> signUp(String email, String name, String password,
      String phone, String username, String degree) {
    return UsersRepository.signUp(
        email, name, password, phone, username, degree);
  }

  bool isValidEmail(String name) {
    return UsersRepository.isValidEmail(name);
  }

  bool isValidPassword(String name) {
    return UsersRepository.isValidPassword(name);
  }

  Future<Response> logIn() async {
    return await UsersRepository.logIn();
  }

  Future<Map<String, dynamic>> loginVerifier(TextEditingController email,
      TextEditingController password, Response response) async {
    return await UsersRepository.loginVerifier(email, password, response);
  }
}
