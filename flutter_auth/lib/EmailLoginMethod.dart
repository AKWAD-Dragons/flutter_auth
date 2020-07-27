import 'dart:convert';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/NetworkProvider/APIManager.dart';
import 'package:fly_networking/fly.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' show Response;

import 'package:flutter/material.dart';
import 'AuthProviderUser.dart';

import 'AuthMethod.dart';
import 'UserInterface.dart';

class EmailLoginMethod implements AuthMethod {
  @override
  String serviceName = 'email';
  final APIManager _apiManager = GetIt.instance<APIManager>();

  /// `Map` that gets called in REST `API` case
  Map<dynamic, dynamic> restLoginMap;

  /// `Map` that gets called in `GraphQL` case
  Node graphLoginNode;

  String apiLink;

  /// How you expect to find the token in responce, `Map`, to be `String`, `Map`, `dynamic`, ...
  Object tokenKey;

  /// How you expect to find the error in responce, `Map`, to be `String`, `Map`, `dynamic`, ...
  Object errorKey;
  Function(Object error) errorFunction;

  Fly fly;

  EmailLoginMethod.rest({
    @required this.restLoginMap,
    @required this.apiLink,
    @required this.errorKey,
    @required this.errorFunction,
  }) {
    fly = Fly(this.apiLink);
  }
  EmailLoginMethod.graphQL({
    @required this.graphLoginNode,
    @required this.apiLink,
  }) {
    fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    /// assure that one of two ways exists
    assert(restLoginMap == null && graphLoginNode == null);

    if (restLoginMap != null) {
      return _restAuth();
    } else if (graphLoginNode != null) {
      return _graphQLAuth();
    }
  }

  Future<AuthUser> _restAuth() async {
    Map _responseMap;
    _apiManager.setEncodedBodyFromMap(map: restLoginMap);
    await _apiManager.post(apiLink).then((Response response) {
      _responseMap = jsonDecode(response.body);
    });

    if (_responseMap.containsKey(errorKey)) {
      errorFunction(errorKey);
    } else {
      return AuthProviderUser()..accessToken = _responseMap[tokenKey];
    }
  }

  Future<AuthUser> _graphQLAuth() async {
    Map result = await fly.mutation([graphLoginNode],
        parsers: {graphLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[graphLoginNode.name];
    return user;
  }

  @override
  Future<void> logout() {
    return null;
  }
}
