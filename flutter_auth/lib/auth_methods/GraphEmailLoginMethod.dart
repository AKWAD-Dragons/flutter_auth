import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import 'package:flutter/material.dart';

import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class GraphEmailLoginMethod implements AuthMethod {
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

  Fly _fly;

  String language;

  GraphEmailLoginMethod({
    @required this.graphLoginNode,
    @required this.apiLink,
    this.language,
  }) {
    _fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    fly.addHeaders({'lang': language});
    Map result = await fly.mutation([graphLoginNode],
        parsers: {graphLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[graphLoginNode.name];
    return user;
  }

  @override
  Future<void> logout() async {
    await _fly.mutation([Node(name: 'logout_user')]);
  }
}
