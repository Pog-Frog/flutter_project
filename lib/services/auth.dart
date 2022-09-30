import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:fluffy/services/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../modules/user.dart';

class Auth extends ChangeNotifier {
  bool _isloggedIn = false;

  User _user = User();
  String _token = '';
  bool get authenticated => _isloggedIn;
  User get user => _user;

  final storage = new FlutterSecureStorage();

  void signup(Map creds, File _image) async {
    if (_image != null) {
      Dio.FormData formData = Dio.FormData.fromMap({
        "name": creds['name'],
        "email": creds['email'],
        "password": creds['password'],
        "image": await Dio.MultipartFile.fromFile(_image.path),
      });
      try {
        Response response = await dio().post('/admin/signup', data: formData);
        print(response.data);
        _token = response.data['token'];
        _user = User.fromJson(response.data['user']);
        _isloggedIn = true;
        await storage.write(key: 'token', value: _token);
        notifyListeners();
      } on DioError catch (e) {
        print(e.response!.data);
      }
    } else {
      try {
        Response response = await dio().post('/admin/signup', data: creds);
        print(response.data);
        _token = response.data['token'];
        _user = User.fromJson(response.data['user']);
        _isloggedIn = true;
        await storage.write(key: 'token', value: _token);
        notifyListeners();
      } on DioError catch (e) {
        print(e.response!.data);
      }
    }
  }

  void login(Map creds) async {
    Dio.Response response = await dio().post('/admin/login', data: creds);
    String token = response.data.toString();
    this.tryToken(token: token);
  }

  Future<void> tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/admin/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isloggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token);

        notifyListeners();
        print("user: ${this._user.name}");
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken(String token) async {
    this.storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    try {
      Dio.Response response = await dio().get('/admin/logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._user = User();
    this._isloggedIn = false;
    this._token = '';
    await storage.delete(key: 'token');
  }
}
