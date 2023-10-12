import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic daoGetProducts() async {
  final url =
      Uri.parse('https://creative-mole-46.hasura.app/api/rest/post/all');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}

dynamic daoLogIn() async {
  final url =
      Uri.parse('https://creative-mole-46.hasura.app/api/rest/users/all');
  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(
    url,
    headers: headers,
  );
  return json.decode(response.body);
}

dynamic daoSignUp(String email, String name, String password, String phone,
    String username, String degree) async {
  final url =
      Uri.parse('https://creative-mole-46.hasura.app/api/rest/users/signup');

  final Map<String, dynamic> requestBody = {
    "object": {
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "username": username,
      "degree": degree,
    }
  };

  final headers = {
    "content-type": "application/json",
    "x-hasura-admin-secret":
        "mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ",
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
  return json.decode(response.body);
}

dynamic daoCreatePost(
    String enteredDegree,
    String enteredDescription,
    String enteredTitle,
    Bool enteredIsNew,
    String enteredPrice,
    Bool enteredIsRecycled,
    String enteredSubject,
    String imageTextBytes) async {
  final url = Uri.https('creative-mole-46.hasura.app', 'api/rest/post/create');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final Map<String, dynamic> requestBody = {
    "object": {
      "date": DateTime.now().toIso8601String(),
      "degree": enteredDegree,
      "description": enteredDescription,
      "name": enteredTitle,
      "new": enteredIsNew,
      "price": double.tryParse(enteredPrice),
      "recycled": enteredIsRecycled,
      "subject": enteredSubject,
      "urlsImages": imageTextBytes,
      "userId": "b7e0f74e-debe-4dcc-8283-9d6a97e76166"
    }
  };
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
  return json.decode(response.body);
}

dynamic daoLoadProducts(Map<String, String> queryParameters) async {
  final url = Uri.https(
        'creative-mole-46.hasura.app', 'api/rest/post/user', queryParameters);

    final headers= {
      'Content-Type': 'application/json',
      'x-hasura-admin-secret':
          'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
    };
    final response=await http.get(url, headers: headers);
    return json.decode(response.body);
}
