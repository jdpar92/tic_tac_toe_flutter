

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tic_tac_toe/graphql/mutations/auth.mutation.dart';
import 'package:tic_tac_toe/stateful_widgets/sign_in_form.dart';

class AuthenticationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Mutation(
      options: MutationOptions(
        document: tokenLogin,
      ),
      builder: (
          RunMutation runMutation,
          QueryResult result,
          ) {
        print('builder');
        print(result.data);
        if(result.data == null) {
          return SignInForm();
        } else {
          return Text('${result.data}');
        }
      },
    );

  }


}