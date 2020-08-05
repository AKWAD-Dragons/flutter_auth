import 'package:flutter/material.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import 'AuthMethod.dart';
import 'AuthProviderUser.dart';

import 'UserInterface.dart';

class EmailSignupMethod implements AuthMethod {
  @override
  String serviceName = 'email';

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
    // @required this.restSignupMap,
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
    assert(graphSignupNode != null);
      return _graphQLAuth();
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
