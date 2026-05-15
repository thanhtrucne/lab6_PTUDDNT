import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHelper {
  static bool isTokenValid(String token) {
    return !JwtDecoder.isExpired(token);
  }

  static Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  static List<String> getRoles(String token) {
    final decoded = decodeToken(token);
    final roles = decoded['role'] ?? decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
    if (roles is String) return [roles];
    if (roles is List) return List<String>.from(roles);
    return [];
  }
}
