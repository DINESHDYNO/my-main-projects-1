class ApiEndPoints {
  static final String baseUrl = 'http://192.168.174.209:3000';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = '/api/signup';
  final String loginEmail = '/api/signin';
}
