

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tic_tac_toe/graphql/mutations/auth.mutation.dart';

class SignInForm extends StatefulWidget {

  SignInForm();

  @override
  SignInFormState createState() => SignInFormState();

}

class SignInFormState extends State<SignInForm> {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Mutation(
        options: MutationOptions(
          document: login,
        ),
        builder: (RunMutation runMutation, QueryResult result) {
          return Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (formKey.currentState.validate()) {
                          // Process data.
                          print(emailController.text);
                          print(passwordController.text);
                          runMutation({
                          });
                        }
                      },
                      child: Text('Sign In'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (formKey.currentState.validate()) {
                          // Process data.
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                )
              ],
            )
          );
        }
      )
    );
  }

}