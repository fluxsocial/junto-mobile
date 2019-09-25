import 'dart:convert';

import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/global_search/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchProvider {
  static List<MemberPreviewModel> mockData = <MemberPreviewModel>[
    MemberPreviewModel(
      name: 'Eric Yang',
      prewviewImage: 'assets/images/junto-mobile__eric.png',
      userName: 'sunyata',
    ),
    MemberPreviewModel(
      name: 'Dora',
      prewviewImage: 'assets/images/junto-mobile__dora.png',
      userName: 'Dora',
    ),
    MemberPreviewModel(
      name: 'Drea',
      prewviewImage: 'assets/images/junto-mobile__drea.png',
      userName: 'Drea',
    ),
    MemberPreviewModel(
      name: 'Kevin',
      prewviewImage: 'assets/images/junto-mobile__kevin.png',
      userName: 'Kevin',
    ),
    MemberPreviewModel(
      name: 'Josh',
      prewviewImage: 'assets/images/junto-mobile__josh.png',
      userName: 'Josh',
    ),
  ];

  Future<List<UserProfile>> searchMember(String query) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String authKey = _prefs.getString('auth');

    final Uri _uri = Uri.http(
      '198.199.67.10',
      '/users',
      <String, String>{'username': query},
    );

    final http.Response _serverResponse = await http.get(
      _uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'cookie': 'auth=$authKey',
      },
    );
    if (_serverResponse.statusCode == 200) {
      final Iterable<dynamic> _listData = json.decode(_serverResponse.body);

      if (_listData.isNotEmpty) {
        return _listData
            .map((dynamic data) => UserProfile.fromMap(data))
            .toList(growable: false);
      }
      return <UserProfile>[];
    }
    throw const JuntoException('Forbidden, please log out and log back in');
  }
}
