abstract class AuthUser {
 String expire;
 String jwtToken;
 String role;
 String type;
 
 AuthUser fromJson(Map<String,dynamic> data);
 Map<String, dynamic> toJson();

}
