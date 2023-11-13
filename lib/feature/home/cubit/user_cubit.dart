import 'package:find_me_tech_task/core/exception/network_exception.dart';
import 'package:find_me_tech_task/data/user_service/user_service.dart';
import 'package:find_me_tech_task/feature/home/cubit/user_state.dart';
import 'package:find_me_tech_task/feature/home/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required this.userService,
  }) : super(
          UserState(),
        );
  final UserService userService;



  Future<String?> getProfilePicture(int id) async {
    emit(
      state.copyWith(
        userStatus: UserStatus.loading,
      ),
    );

    var result = await userService.getProfilePicture(id);

    if (result.$1 != null) {
      emit(
        state.copyWith(
          userStatus: UserStatus.error,
        ),
      );
    } else {
      return result.$2!.downloadUrl;
    }
    return null;
  }

  Future<void> getUser() async {
    emit(
      state.copyWith(
        userStatus: UserStatus.loading,
      ),
    );
    var result = await userService.getUsers();
    if (result.$1 != null) {
      emit(
        state.copyWith(
          userStatus: UserStatus.error,
        ),
      );
    } else {
      if (result.$2!.isEmpty) {
        emit(
          state.copyWith(
            userStatus: UserStatus.success,
            users: result.$2!,
          ),
        );
      } else {
        setUserProfilePic(result);
      }
    }
  }

  void setUserProfilePic((NetworkException?, List<UserModel>?) result) {
    for (var i = 0; i < result.$2!.length; i++) {
      getProfilePicture(result.$2![i].id!)
        ..then((pictureModel) {
          result.$2![i].userPictureUrl = pictureModel;
        })
        ..then((value) {
          emit(
            state.copyWith(
              userStatus: UserStatus.success,
              users: result.$2,
            ),
          );
        });
    }
  }

  Future<void> searchUser(String searchText) async {
    emit(
      state.copyWith(
        userStatus: UserStatus.loading,
      ),
    );
    var result = await userService.searchUser(searchText);

    if (result.$1 != null) {
      emit(
        state.copyWith(
          userStatus: UserStatus.error,
        ),
      );
    } else {
      setUserProfilePic(result);
      if (result.$2!.isEmpty) {
        emit(
          state.copyWith(
            userStatus: UserStatus.success,
            users: result.$2!,
          ),
        );
      } else {
        setUserProfilePic(result);
      }
    }
  }
}
