import 'package:chat_app/screens/posts_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up_screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();

  String _email = '';
  String _username = '';
  String _password = '';

  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();

    context.read<AuthCubit>().signUp(
          email: _email,
          username: _username,
          password: _password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (prevState, currentState) {
        if (currentState is AuthSignedUp) {
          Navigator.of(context).pushReplacementNamed(PostsScreen.id);
        }
        if (currentState is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(currentState.message)));
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
            child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CHATappchik',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Enter your e-mail',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_usernameFocusNode);
                      },
                      onSaved: (value) {
                        _email = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _usernameFocusNode,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Enter your username',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (value) {
                        _username = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Enter your password',
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onFieldSubmitted: (_) {
                        _submit(context);
                      },
                      onSaved: (value) {
                        _password = value!.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 5) {
                          return 'Please enter longer your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text('Sign up')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.id);
                        },
                        child: const Text('Sign in screen')),
                  ],
                ),
              ),
            ),
          ),
        ));
      }),
    );
  }
}
