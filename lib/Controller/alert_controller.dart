import 'dart:async';
import 'package:unishop/Model/DAO/dao.dart';


class AlertController {

  void callSearchAlerts() {
    const duration = const Duration(seconds: 40);
    Timer.periodic(duration, (Timer t) {
      // Llama a la función searchAlerts aquí
      daoSearchAlert();
    });
  }

}





