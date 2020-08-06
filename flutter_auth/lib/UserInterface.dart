abstract class AuthUser {
 String expire;
 String id;
 String token;
 String role;
 String type;
 
 AuthUser fromJson(Map<String,dynamic> data);
 Map<String, dynamic> toJson();

}
