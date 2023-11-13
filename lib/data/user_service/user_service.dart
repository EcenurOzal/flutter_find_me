import 'dart:convert';

import 'package:find_me_tech_task/feature/home/model/profile_picture_model.dart';

import '../../core/exception/network_exception.dart';
import '../../core/network/api_helper.dart';
import '../../feature/home/model/user_model.dart';

class UserService {
  ApiHelper helper;
  UserService({
    required this.helper,
  });

  Future<(NetworkException?, List<UserModel>?)> getUsers() async {
    List<UserModel> result = [];
    final response = await helper.request(
      method: HttpMethod.get,
      url: 'https://jsonplaceholder.typicode.com/users',
    );

    //?Api helperdan hata durumu döndüyse 
    if (response.$1 != null) {
      return (response.$1, null);
    } else if (response.$2 != null) {
      var jsonList = json.decode(response.$2!.body.toString()) as List;

      result = jsonList
          .map((jsonElement) => UserModel.fromJson(jsonElement))
          .toList();

      return (null, result);
    } else {
      return (null, null);
    }
  }

  Future<(NetworkException?, List<UserModel>?)> searchUser(
      String searchText) async {
    List<UserModel> result = [];

    final response = await helper.request(
      method: HttpMethod.get,
      url: 'https://jsonplaceholder.typicode.com/users?username=$searchText',
    );

 
    if (response.$1 != null) {
      return (response.$1, null);
    } else if (response.$2 != null) {
      var jsonList = json.decode(response.$2!.body.toString()) as List;

      result = jsonList
          .map((jsonElement) => UserModel.fromJson(jsonElement))
          .toList();

      return (null, result);
    } else {
      return (null, null);
    }
  }

  Future<(NetworkException?, ProfilePicture?)> getProfilePicture(int id) async {
    ProfilePicture result;

    final response = await helper.request(
      method: HttpMethod.get,
      url: 'https://picsum.photos/id/$id/info',
    );

    if (response.$1 != null) {
      return (response.$1, null);
    } else if (response.$2 != null) {
      var jsonList = json.decode(response.$2!.body.toString());

      result = ProfilePicture.fromJson(jsonList);

      return (null, result);
    } else {
      return (null, null);
    }
  }
}
