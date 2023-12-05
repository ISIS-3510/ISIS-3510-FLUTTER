import 'package:unishop/Model/Repository/bug_repository.dart';

class BugController {
  Future<void> addBugReport(String bug) async {
    return BugRepository.addBugReport(bug);
  }
}