import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

import 'package:get_it/get_it.dart';
import 'AuthMethod.dart';
import 'AuthProviderUser.dart';

import 'UserInterface.dart';

class EmailSignupMethod implements AuthMethod {
  @override
  String serviceName = 'email';
  final APIManager _apiManager = GetIt.instance<APIManager>();

  /// `Map` that gets called in REST `API` case
  Map<dynamic, dynamic> restSignupMap;

  /// `Map` that gets called in `GraphQL` case
  Node graphSignupNode;

  String apiLink;

  /// How you expect to find the token in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object tokenKey;

  /// How you expect to find the error in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object errorKey;
  Function(Object error) errorFunction;

  Fly fly;

  EmailSignupMethod.rest({
    @required this.restSignupMap,
    @required this.apiLink,
    @required this.errorKey,
    @required this.errorFunction,
  }) {
    fly = Fly(this.apiLink);
  }
  EmailSignupMethod.graphQL({
    @required this.graphSignupNode,
    @required this.apiLink,
  }) {
    fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    /// assure that one of two ways exists
    assert(restSignupMap == null && graphSignupNode == null);

    if (restSignupMap != null) {
      return _restAuth();
    } else if (graphSignupNode != null) {
      return _graphQLAuth();
    }
  }

  Future<AuthUser> _restAuth() async {
    Map responseMap;
    _apiManager.setEncodedBodyFromMap(map: restSignupMap);
    await _apiManager.post(apiLink).then((Response response) {
      responseMap = jsonDecode(response.body);
    });

    if (responseMap.containsKey(errorKey)) {
      errorFunction(errorKey);
    } else {
      return AuthProviderUser()..accessToken = responseMap[tokenKey];
    }
  }

  Future<AuthUser> _graphQLAuth() async {
    await fly.mutation([this.graphSignupNode]);
    return AuthProviderUser();
  }

  @override
  Future<void> logout() {
    return null;
  }
}
