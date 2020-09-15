import 'package:auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';

import 'package:get_it/get_it.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    GetIt.instance
        .registerLazySingleton<AuthProvider>(() => AuthProvider(User()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Auth Provider example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Text("signup with email"),
                onPressed: () async {
                  User myUser = await signup();
                  print(myUser);
                },
              ),
              RaisedButton(
                child: Text("login with email"),
                onPressed: () async {
                  User myUser = await login();
                  print(myUser);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AuthUser> login() async {
    return await _authProvider.loginWith(
      callType: (AuthUser authuser) async {
        //Fetch data from AuthUser object to your user object
        return User();
      },
      method: GraphEmailLoginMethod(
        apiLink: "MyLink",
        graphLoginNode: Node(
          name: "nodeName",
          args: {},
          cols: [],
        ),
      ),
    );
  }

  Future<AuthUser> signup() async {
    return await _authProvider.signUpWithEmail(
      callType: (AuthUser authuser) async {
        //Fetch data from AuthUser object to your user object
        return User();
      },
      method: GraphEmailSignupMethod(
        apiLink: "MyLink",
        graphSignupNode: Node(
          name: "nodeName",
          args: {},
          cols: [],
        ),
      ),
    );
  }
}

class User implements AuthUser {
  @override
  String expire;
  @override
  String id;
  @override
  String role;
  @override
  String token;
  @override
  String type;
  @override
  AuthUser fromJson(Map<String, dynamic> data) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
