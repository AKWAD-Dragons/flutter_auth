import 'package:flutter/material.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class GraphEmailSignupMethod implements AuthMethod {
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

  String language;

  GraphEmailSignupMethod(
      {@required this.graphSignupNode,
      @required this.apiLink,
      @required this.fly,
      this.language});

  @override
  Future<AuthUser> auth() async {
    if (language != null) {
      fly.addHeaders({'lang': language});
    }
    await fly.mutation([this.graphSignupNode]);
    return AuthProviderUser();
  }

  @override
  Future<void> logout() async {
    await fly.mutation([Node(name: 'logout_user')]);
  }
}
