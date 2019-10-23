import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SearchProviderCentralized implements SearchProvider {
  const SearchProviderCentralized(this.client);

  final JuntoHttp client;

  // FIXME docs required
  @override
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
      final Iterable<dynamic> _listData = convert.json.decode(_serverResponse.body);

      if (_listData.isNotEmpty) {
        return _listData.map((dynamic data) => UserProfile.fromMap(data)).toList(growable: false);
      }
      return <UserProfile>[];
    }
    throw const JuntoException('Forbidden, please log out and log back in');
  }
}
