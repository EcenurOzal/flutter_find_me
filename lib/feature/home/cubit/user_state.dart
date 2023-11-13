// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:find_me_tech_task/feature/home/model/profile_picture_model.dart';
import 'package:find_me_tech_task/feature/home/model/user_model.dart';

enum UserStatus {
  initial,
  loading,
  error,
  success,
}

class UserState {
  final UserStatus userStatus;
  final List<UserModel>? users;

  UserState({
    this.users,
    this.userStatus = UserStatus.initial,
  });

  UserState copyWith({
    UserStatus? userStatus,
    List<UserModel>? users,
    List<ProfilePicture>? userProfilePictures,
  }) {
    return UserState(
      userStatus: userStatus ?? this.userStatus,
      users: users ?? this.users,
    );
  }
}
