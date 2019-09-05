import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

abstract class UserProvider {
  Future<PerspectiveResponse> createPerspective(Perspective perspective);
}

class UserProviderImpl implements UserProvider {
  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<PerspectiveResponse> createPerspective(Perspective perspective) async {
    const String resource = '/holochain';

    final Map<String, dynamic> body = <String, dynamic>{
      'zome': 'perspective',
      'function': 'create_perspective',
      'args': <String, String>{
        'name': perspective.name,
      },
    };

    final http.Response serverResponse =
        await JuntoHttp().post(resource, body: body);
    //ignore: always_specify_types
    final responseMap = deserializeJsonRecursively(serverResponse.body);
    if (responseMap['Ok'] != null) {
      final PerspectiveResponse perspectiveDetails =
          PerspectiveResponse.fromMap(
        responseMap['Ok'],
      );
      return perspectiveDetails;
    }

    if (responseMap['result']['Err'] != null) {
      print(responseMap['result']['Err']);
    }

    // Should not get here.
    return null;
  }
}
