import 'package:flutter/material.dart';

import '../model/model.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.model,
  });

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        model.userPictureUrl ?? '',
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person);
        },
      ),
      title: Text(
        model.name ?? ' ',
      ),
      subtitle: Text(
        model.username ?? ' ',
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }
}
