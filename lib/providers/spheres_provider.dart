import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:http/http.dart' as http;

abstract class SpheresProvider with ChangeNotifier {
  List<Sphere> get spheres;

  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere);
}

class SphereProviderCentralized with ChangeNotifier implements SpheresProvider {
  @override
  Future<CentralizedSphereResponse> createSphere(
    CentralizedSphere sphere,
  ) async {
    final _postBody = sphere.toMap();
    final http.Response _serverResponse = await JuntoHttp().postWithoutEncoding(
      '/groups',
      body: _postBody,
    );
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return CentralizedSphereResponse.fromJson(_decodedResponse);
  }

  @override
  List<Sphere> get spheres => Sphere.fetchAll();
}

@Deprecated('This should only be used for testing.')
class MockSphere with ChangeNotifier implements SpheresProvider {
  final List<Sphere> _spheres = Sphere.fetchAll();

  @override
  List<Sphere> get spheres {
    return _spheres;
  }

  @override
  Future<CentralizedSphereResponse> createSphere(CentralizedSphere sphere) {
    throw UnimplementedError();
  }
}
