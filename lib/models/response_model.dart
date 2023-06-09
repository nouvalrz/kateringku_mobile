class ResponseModel {
  final bool _isSuccess;
  final String _message;
  final String _type;

  ResponseModel(this._isSuccess, this._message, this._type);

  String get message => _message;
  bool get isSuccess => _isSuccess;
  String get type => _type;
}
