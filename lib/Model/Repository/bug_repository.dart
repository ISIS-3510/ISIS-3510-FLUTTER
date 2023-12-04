import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/Model/DAO/dao.dart';

class BugRepository {
  static void addBugReport(String bug) async {
    final prefs = await SharedPreferences.getInstance();
    daoAddBugReport(bug, prefs.getString('user_id')!);
  }
}