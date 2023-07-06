import 'package:chatonym/Backend/Auth_Service/auth_service.dart';
import 'package:chatonym/Constants/consts.dart';
import 'package:chatonym/utils/web_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../route/routes.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App Name  2 text form fields for email and password
    // 1 button for signup
    return WebConstraint(
      // web constraint limits max width of the screen
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConst.logo,
                height: 75,
              ),
              //  APP NAME
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Chatonym',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              //  2 TEXT FORM FIELDS FOR EMAIL AND PASSWORD
              Form(
                // This will validate the form
                key: _formKey,
                child: Column(
                  children: [
                    // EMAIL TEXT FORM FIELD
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      // PASSWORD TEXT FORM FIELD
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
              ),
              //  SIGNUP BUTTON
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // call the create account function
                      ref.read(authProvider).createAccount(
                            emailController.text,
                            passwordController.text,
                            context,
                          );
                    }
                  },
                  // SIGNUP BUTTON CONTAINER
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                'Or',
                style: TextStyle(
                  color: Color.fromARGB(98, 0, 0, 0),
                  fontSize: 16,
                ),
              ),
              //  SIGNUP WITH GOOGLE BUTTON
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // call the google sign in function
                    ref.read(authProvider).singInWithGoogle(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/google_logo.png'),
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sign Up with Google',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //  LOGIN link
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.loginRoute);
                },
                child: const Text(
                  'Already a member? Login',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
