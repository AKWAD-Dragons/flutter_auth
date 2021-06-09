import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import 'package:get_it/get_it.dart';

import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class GraphEmailLoginMethod implements AuthMethod {
  @override
  String serviceName = 'email';

  /// `Map` that gets called in `GraphQL` case
  Node graphLoginNode;

  String? apiLink;

  /// How you expect to find the token in responce, `Map`, to be `String`, `Map`, `dynamic`, ...
  Object? tokenKey;

  /// How you expect to find the error in responce, `Map`, to be `String`, `Map`, `dynamic`, ...
  Object? errorKey;
  Function(Object error)? errorFunction;

  Fly _fly;

  GraphEmailLoginMethod({required this.graphLoginNode})
      : _fly = GetIt.instance<Fly>();

  @override
  Future<AuthUser> auth() async {
    Map result = await _fly.mutation([graphLoginNode],
        parsers: {graphLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[graphLoginNode.name];
    return user;
  }

  @override
  Future<void> logout() async {
    await _fly.mutation([Node(name: 'logout_user')]);
  }
}
