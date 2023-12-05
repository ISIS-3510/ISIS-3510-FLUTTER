import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unishop/Model/DTO/user_dto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

dynamic daoSearchUserByUsername(String username) async {
  final url = Uri.parse('https://creative-mole-46.hasura.app/api/rest/users/all');
  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret': 'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(
    url,
    headers: headers,
  );

  if (response.statusCode == 200) {
    final List<dynamic> users = json.decode(response.body)["users"];
    final matchingUser = users.firstWhere(
      (user) => user["username"] == username,
      orElse: () => null,
    );
    print(matchingUser);
    return matchingUser;
  } else {
    return null;
  }
}


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
  return response;
}

dynamic daoSignUp(String email, String name, String password, String phone,
    String username, String degree) async {
  UserDTO user = UserDTO(
      email: email,
      name: name,
      password: password,
      phone: phone,
      username: username,
      degree: degree);
  final url =
      Uri.parse('https://creative-mole-46.hasura.app/api/rest/users/signup');

  final Map<String, dynamic> requestBody = {
    "object": user.toJson()
  };
  // final Map<String, dynamic> requestBody = {
  //   "object": {
  //     "email": email,
  //     "name": name,
  //     "password": password,
  //     "phone": phone,
  //     "username": username,
  //     "degree": degree,
  //   }
  // };

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
      "degree": enteredDegree ?? "",
      "description": enteredDescription ?? "",
      "name": enteredTitle,
      "new": enteredIsNew,
      "price": double.tryParse(enteredPrice),
      "recycled": enteredIsRecycled,
      "subject": enteredSubject ?? "",
      "urlsImages": image,
      "userId": userId,
    }
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
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

Future<String> daoSaveImage(file) async {
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceImageToUpload = referenceRoot.child(uniqueFileName);
  await referenceImageToUpload.putFile(File(file.path));
  return await referenceImageToUpload.getDownloadURL();
}

dynamic daoCreateAlert(String latitude, String longitude, String id) async {

  final url = Uri.https('creative-mole-46.hasura.app', 'api/rest/alert/create');

  const headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };

  final Map<String, dynamic> requestBody = {
    "object": {
      "danger": 5,
      "latitude": latitude,
      "longitude": longitude,
      "user_id": id
    }
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
  return json.decode(response.body);

}

dynamic daoSearchAlert() async {

  final url = 'https://creative-mole-46.hasura.app/api/rest/alert/all';

  const headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // Procesar la respuesta si es exitosa
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> alerts = data['alert'];


      //Iterar sobre la lista de alertas
      for (var alert in alerts) {

        print('User: ${alert['user']['username']} Date: ${alert['date']}');
        var difSec = calculateAbsoluteDateDifferenceInSeconds(alert['date'], getCurrentDate());
        if(difSec < 300){


          print('Active: ${alert['active']}');
          print('Alert ID: ${alert['id']}');
          print('Latitude: ${alert['latitude']}');
          print('Longitude: ${alert['longitude']}');
          print('Date: ${alert['date']}');
          print('Danger: ${alert['danger']}');
          print('User Name: ${alert['user']['name']}');
          print('User Username: ${alert['user']['username']}');
          print('-----------');
          print(difSec);

          var username = alert['user']['username'];
          var lat = alert['latitude'];
          var log = alert['longitude'];

          var msj = "it appears that $username is in danger in latitude: $lat longitude: $log";

          showNotificacion("HELP!", msj);

        }
      }
    } else {
      print(
          'Error durante la solicitud GET. Código de estado: ${response.statusCode}, Cuerpo de respuesta: ${response.body}');
    }
  } catch (e) {
    print('Error en la solicitud GET: $e');
  }

}

double calculateAbsoluteDateDifferenceInSeconds(String startDate, String endDate) {
  DateTime startDateTime = DateTime.parse(startDate);
  DateTime endDateTime = DateTime.parse(endDate);

  int differenceInSeconds = endDateTime.difference(startDateTime).inSeconds;
  double absoluteDifference = differenceInSeconds.abs().toDouble();
  return absoluteDifference;
}


String getCurrentDate() {
  DateTime now = DateTime.now().toUtc();
  String formattedDate =
      '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}T${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}.${_addLeadingZero(now.millisecond)}+00:00';
  return formattedDate;
}

String _addLeadingZero(int value) {
  if (value < 10) {
    return '0$value';
  }
  return value.toString();
}

// Instancia del package
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


// Este es el método que inicializa el objeto de notificaciones
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  
  var areNotificationsEnabled =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled();

    if (areNotificationsEnabled != null && !areNotificationsEnabled) {
      // Las notificaciones no están habilitadas
      print('Las notificaciones locales no están habilitadas');
    } else {
      // Las notificaciones están habilitadas
      print('Las notificaciones locales están habilitadas');
    }

}


// Este es el método que muestra la notificación
Future<void> showNotificacion(String titulo, String body) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
      1,
      titulo,
      body,
      notificationDetails);

}

dynamic daoAddFavorite(
    String postId,
    String? userId) async {
  final url = Uri.https('creative-mole-46.hasura.app', 'api/rest/favorites/add');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final Map<String, dynamic> requestBody = {
    "object": {
      "post_id": postId,
      "user_id": userId,
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

dynamic daoDeleteFavorite(
    String postId,
    String? userId) async {
  final url = Uri.https('creative-mole-46.hasura.app', 'api/rest/favorites/delete');
  final headers = {
    'content-type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final Map<String, dynamic> requestBody = {
      "post_id": postId,
      "user_id": userId,
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(requestBody),
  );
  print(response.body);
  return json.decode(response.body);
}

dynamic daoGetFavorites(queryParameters) async {
  final url = Uri.https(
      'creative-mole-46.hasura.app', 'api/rest/favorites/user', queryParameters);

  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
        'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}

dynamic daoGetUser(queryParameters) async {
  final url = Uri.https(
      'creative-mole-46.hasura.app', 'api/rest/users/user', queryParameters);

  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
    'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };
  final response = await http.get(url, headers: headers);
  return json.decode(response.body);
}

dynamic daoSoldProduct(String postId,
    String userId) async {
  final url = Uri.https(
      'creative-mole-46.hasura.app', 'api/rest/sold');

  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
    'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };

  final Map<String, dynamic> requestBody = {
    "post_id": postId,
    "user_id": userId,
    "soldDate": DateTime.now().toIso8601String(),
  };

  final response = await http.post(url, headers: headers, body: jsonEncode(requestBody));
  return json.decode(response.body);
}

dynamic daoUnsoldProduct(String postId,
    String userId) async {
  final url = Uri.https(
      'creative-mole-46.hasura.app', 'api/rest/notsold');

  final headers = {
    'Content-Type': 'application/json',
    'x-hasura-admin-secret':
    'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
  };

  final Map<String, dynamic> requestBody = {
    "post_id": postId,
    "user_id": userId,
  };

  final response = await http.post(url, headers: headers, body: jsonEncode(requestBody));
  return json.decode(response.body);
}

dynamic daoAddBugReport(String bug, String userId) async {
  final url = Uri.https(
      'image-repository-53ee3-default-rtdb.firebaseio.com', 'bug-list.json');

  final headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> requestBody = {
      userId : bug,
  };

  final response = await http.post(url, headers: headers, body: jsonEncode(requestBody));
  return json.decode(response.body);
}