import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unishop/dao/dao.dart';

class UsersRepository {
  static Future<Response> signUp (String email, String name, String password, String phone,
    String username, String degree) async {
      return await daoSignUp(email, name, password, phone, username, degree);
  }

  static Future<Response> logIn () async {
    return await daoLogIn();
  }

  static Future<Map<String, dynamic>> loginVerifier (TextEditingController emailController, TextEditingController passwordController, Response response) async{
    final data = json.decode(response.body);
    final users = data['users'];

    // Check if there is a user with the provided email and password
    final matchingUser = users.firstWhere(
      (user) =>
          user['email'] == emailController.text &&
          user['password'] == passwordController.text,
      orElse: () => null,
    ); 
    return matchingUser;
  }
    

  static bool isValidName(String name) {
    bool rta = false;
    if(name.trim().isNotEmpty){
      rta = true;
    }
    return rta;
  }

  static bool isValidUserName(String userName) {
    bool rta = false;

    if(userName.trim().isNotEmpty){
      rta = true;
    }

    return rta;
  }

  static bool isValidDegree(String degree) {
    bool rta = false;

    if(degree.trim().isNotEmpty){
      rta = true;
    }

    return rta;
  }

  static bool isValidPhone(String phone) {
    bool rta = false;

    if(phone.length == 10){
      rta = true;
    }
    return rta;
  }

  static bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]'))) {
      return false;
    }
    return true;
  }

  static bool isValidConfirmPassword(String confirmPassword, String password) {

    return confirmPassword == password;
  }
}