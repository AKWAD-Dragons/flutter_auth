<style>
h1 {text-align: center;}1
</style>

# 🔒 *Flutter Auth* 🔑
One package for all your authentications.

---

## 🔧  Installation 
```
dependencies:
  auth_provider: [latest-version]
```
---
## 📃 Setup 
First register the singleton object of the **AuthProvider** class
```
GetIt.instance.registerLazySingleton<AuthProvider>(() => AuthProvider(User()));
```

Then, run this command in terminal.
```
$ flutter packages pub
```
---
## ⚡ Usage
Create the node to send it in the request.
```
Node _loginNode = Node(
    name: "",
    args: {
        //arguments
    },
    cols: [
        //columns
    ],
);
```

create an instance of your auth method. You can choose between GraphQl auth or restApi request, and you can choose between login or signup.
```
GraphEmailLoginMethod _loginMethod = GraphEmailLoginMethod(_loginNode, "API_Link");
```

Then, we use the login/signup function, and pass the auth method, and call type to it.
```
await GetIt.instance<AuthProvider>().loginWith(
    callType: _loginWithEmailCallType,
    method: _signupMethod
);
```

### ⚠️ *Your implemented **User** class must extend **AuthUser** class*⚠️ 
Call type is a function called after the recieving api responce, and it mainly fetches data of the package's generic user object of type **AuthUser** and add these values to an object of your implemented User class, then return the object as an **AuthUser**.

```
Future<AuthUser> _loginWithEmailCallType(AuthUser user) async {
    return User()
        ..id = user.id
        ..jwtToken = user.token
        ..role = user.role
        ..expire = user.expire;
}
```

