class ServerException implements Exception{
  late final String code;
  late final String? message;

  ServerException(this.code, [this.message]);

  @override
  String toString() => 'Server exception(code: $code, message: $message)';
}