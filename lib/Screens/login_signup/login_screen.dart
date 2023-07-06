import 'package:chatonym/Backend/Auth_Service/auth_service.dart';
import 'package:chatonym/Constants/consts.dart';
import 'package:chatonym/utils/web_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends ConsumerState<LoginScreen> {
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
    // 2 Text form fields and a button
    return WebConstraint(
      child: Scaffold(
        body: Center(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConst.logo,
                height: 75,
              ),
              // APP NAME
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Chatonym',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Form(
                // form key for 2 text form fields
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      //  email text form field
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
                      // password text form field
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
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
              ),
              // FORGOT PASSWORD BUTTON
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      // check if the email is empty
                      if (emailController.text.isEmpty) {
                        // show a snackbar if the email is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your email'),
                          ),
                        );
                      } else {
                        // call the forgot password function
                        ref.read(authProvider).resetPassword(
                              emailController.text,
                              context,
                            );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )),
              // LOGIN BUTTON
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // call the login account function
                      ref.read(authProvider).loginAccount(
                            emailController.text,
                            passwordController.text,
                            context,
                          );
                    }
                  },
                  // LOGIN BUTTON CONTAINER
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
