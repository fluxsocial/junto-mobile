import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockSearch implements SearchService {
  @override
  Future<QueryResults<UserProfile>> searchMembers(
    String query, {
    bool username = false,
    int paginationPosition = 0,
    DateTime lastTimeStamp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return QueryResults<UserProfile>(
      lastTimestamp: DateTime.now().toIso8601String(),
      results: List<void>.generate(100, (int index) => kUserProfile),
    );
  }

  @override
  Future<QueryResults<String>> searchChannel(String query, {int paginationPosition = 0, DateTime lastTimeStamp}) {
    // TODO: implement searchChannel
    throw UnimplementedError();
  }

  @override
  Future<QueryResults<Group>> searchSphere(String query, {int paginationPosition = 0, DateTime lastTimeStamp}) {
    // TODO: implement searchSphere
    throw UnimplementedError();
  }
}
