import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import 'package:flutter/material.dart';
import 'AuthProviderUser.dart';

import 'AuthMethod.dart';
import 'UserInterface.dart';

class EmailLoginMethod implements AuthMethod {
  @override
  String serviceName = 'email';

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
    assert(graphLoginNode != null);

      return _graphQLAuth();
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
