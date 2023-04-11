class User {
  String _id;
  String _username;
  String _password;
  String _email;
  String _address;
  String _image;
  bool _isVerified;
  bool _isDeleted;

  User(
    this._id,
    this._username,
    this._password,
    this._email,
    this._address,
    this._image,
    this._isVerified,
    this._isDeleted,
  );

  String get id => _id;
  String get username => _username;
  String get password => _password;
  String get email => _email;
  String get address => _address;
  String get image => _image;
  bool get verified => _isVerified;
  bool get deleted => _isDeleted;

  set id(id) => _id = id;
  set username(username) => _username = username;
  set password(password) => _password = password;
  set email(id) => _email = email;
  set address(id) => _address = address;
  set image(id) => _image = image;
  set verified(id) => _isVerified = id;
  set deleted(id) => _isDeleted = id;

  @override
  String toString() {
    return _id +
        _username +
        _password +
        _email +
        _address +
        _image +
        _isVerified.toString();
  }
}
