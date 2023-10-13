import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

dynamic daoGetProducts() async {
  final url =
      Uri.parse('https://creative-mole-46.hasura.app/api/rest/post/all');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(url, headers: headers);
  return response;
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
  //print(response.body);
  return response;
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
  return response;
}

dynamic daoCreatePost(
    String? enteredDegree,
    String? enteredDescription,
    String enteredTitle,
    bool enteredIsNew,
    String enteredPrice,
    bool enteredIsRecycled,
    String? enteredSubject,
    String image,
    String userId) async {
  final url = Uri.https('creative-mole-46.hasura.app', 'api/rest/post/create');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final Map<String, dynamic> requestBody = {
    "object": {
      "date": DateTime.now().toIso8601String(),
      "degree": enteredDegree ?? "",
      "description": enteredDescription ?? "",
      "name": enteredTitle,
      "new": enteredIsNew,
      "price": double.tryParse(enteredPrice),
      "recycled": enteredIsRecycled,
      "subject": enteredSubject??"",
      "urlsImages": image,
      "userId": userId,
    }
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
  print(response.body);
  return json.decode(response.body);
}

dynamic daoLoadProducts(Map<String, String?> queryParameters) async {
  final url = Uri.https(
      'creative-mole-46.hasura.app', 'api/rest/post/user', queryParameters);

  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}

Future<String> daoSaveImage(file) async{
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceImageToUpload = referenceRoot.child(uniqueFileName);
  await referenceImageToUpload.putFile(File(file.path));
  return await referenceImageToUpload.getDownloadURL();
}
