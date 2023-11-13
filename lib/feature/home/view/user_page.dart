import 'package:find_me_tech_task/core/extensions/context_extension.dart';
import 'package:find_me_tech_task/core/languages/tr.dart';
import 'package:find_me_tech_task/core/network/api_helper.dart';
import 'package:find_me_tech_task/data/user_service/user_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userService: UserService(
          helper: ApiHelper(),
        ),
      )..getUser(),
      child: const UserView(),
    );
  }
}

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Find Me"),
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(UserState state) {
    return switch (state.userStatus) {
      UserStatus.initial => const SizedBox.shrink(),
      UserStatus.loading => _buildLoading(state),
      UserStatus.success => _buildSuccess(state),
      UserStatus.error => _buildError(),
    };
  }

  Center _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TR.errorPageMessage,
            style: context.theme.textTheme.headlineSmall
                ?.copyWith(color: context.getColorSheme().error),
          )
        ],
      ),
    );
  }

  Widget _buildSuccess(UserState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: TR.labelText,
              hintText: TR.searchHintText,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<UserCubit>().getUser();
                },
                icon: const Icon(Icons.cancel),
              ),
            ),
            onChanged: (String character) {
              if (_searchController.text.isEmpty) {
                context.read<UserCubit>().getUser();
              }
            },
            onEditingComplete: () {
              context.read<UserCubit>().searchUser(_searchController.text);
            },
          ),
        ),
        if ((state.users ?? []).isNotEmpty) ...[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.users?.length,
              itemBuilder: (context, index) {
                UserModel model = state.users![index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () async {
                      await _buildPopUp(context, state, index);
                    },
                    child: UserCard(model: model),
                  ),
                );
              },
            ),
          ),
        ] else ...[
          context.verticalSpace(0.2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning),
              context.verticalSpace(0.01),
              const Text(TR.noUserFound),
            ],
          )
        ]
      ],
    );
  }

  Future<dynamic> _buildPopUp(
      BuildContext context, UserState state, int index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            icon: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    minRadius: 40,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(
                      state.users?[index].userPictureUrl ?? '',
                    ),
                  ),
                ),
                context.verticalSpace(0.01),
                Center(
                  child: buildPopUpText(state.users?[index].name ?? '', context,
                      style: context.theme.textTheme.titleMedium),
                ),
                Center(
                  child: buildPopUpText(
                      state.users?[index].email ?? '', context,
                      style: context.theme.textTheme.bodySmall),
                ),
                context.verticalSpace(0.02),
                buildPopUpText(
                    "Email:${state.users?[index].email ?? ''}", context),
                buildPopUpText(
                    "Telefon:${state.users?[index].phone ?? ''}", context),
                buildPopUpText(
                    "Address:${getFullAddressAsString(state.users?[index].address ?? Address())}",
                    context),
                buildPopUpText(
                    "Şehir:${state.users?[index].address?.city ?? ''}",
                    context),
                buildPopUpText(
                    "Konum:${state.users?[index].address?.geo?.lat ?? ''}/${state.users?[index].address?.geo?.lng ?? ''}",
                    context),
              ],
            )));
  }

  Widget buildPopUpText(String text, BuildContext context, {TextStyle? style}) {
    return Text(
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      text,
      style: style ?? context.theme.textTheme.bodySmall,
    );
  }

  Widget _buildLoading(UserState state) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.orange,
      ),
    );
  }

  String getFullAddressAsString(Address address) {
    return "${address.street ?? ""} Street ${address.city ?? ""} / ${address.suite ?? ""} zipcode:${address.zipcode ?? ""}";
  }
}
