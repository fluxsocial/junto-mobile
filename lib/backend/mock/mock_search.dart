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
    String lastTimeStamp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return QueryResults<UserProfile>(
      lastTimestamp: DateTime.now().toIso8601String(),
      results: List<void>.generate(100, (int index) => kUserProfile),
    );
  }

  @override
  Future<QueryResults<Channel>> searchChannel(String query,
      {int paginationPosition = 0, DateTime lastTimeStamp}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return QueryResults<Channel>(
      lastTimestamp: DateTime.now().toIso8601String(),
      results: List<void>.generate(
        100,
        (int index) => Channel(
          name: 'pending',
          createdAt: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Future<QueryResults<Group>> searchSphere(
    String query, {
    int paginationPosition = 0,
    DateTime lastTimeStamp,
    bool handle,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return QueryResults<Group>(
      lastTimestamp: DateTime.now().toIso8601String(),
      results: kGroups,
    );
  }
}
