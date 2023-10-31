import 'package:unishop/Model/Repository/users_repository.dart';
import 'package:http/http.dart';

class SignUpController {
  Future<Response> signUp(String email, String name, String password,
      String phone, String username, String degree) async {
    return await UsersRepository.signUp(
        email, name, password, phone, username, degree);
  }

  bool isValidName(String name) {
    return UsersRepository.isValidName(name);
  }

  bool isValidUserName(String userName) {
    return UsersRepository.isValidUserName(userName);
  }

  bool isValidDegree(String degree) {
    return UsersRepository.isValidDegree(degree);
  }

  bool isValidPhone(String phone) {
    return UsersRepository.isValidPhone(phone);
  }

  bool isValidEmail(String email) {
    return UsersRepository.isValidEmail(email);
  }

  bool isValidPassword(String password) {
    return UsersRepository.isValidPassword(password);
  }

  bool isValidConfirmPassword(String confirmPassword, String password) {
    return UsersRepository.isValidConfirmPassword(confirmPassword, password);
  }
}
