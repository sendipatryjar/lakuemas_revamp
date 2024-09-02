abstract class ITokenLocalDataSource {
  Future<void> saveAccessToken(String accToken);
  Future<String?> getAccessToken();
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
}
