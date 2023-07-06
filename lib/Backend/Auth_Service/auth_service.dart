import 'package:chatonym/route/routes.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// This is the provider for the firebase auth
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
//
// This is the provider for the [AuthService]
final authProvider = Provider(
  (ref) => AuthService(ref),
);
//
// User changes Provider
final authStateChangesProvider = StreamProvider(
  (ref) {
    final a = ref.watch(firebaseAuthProvider);
    return a.authStateChanges();
  },
);

class AuthService {
  // signup fuctions will be here
  final Ref _ref;

  AuthService(this._ref);

  // This function will create the user
  void createAccount(
      // This function will create a new user account
      // If the email is already in use, it will show a dialog
      // asking the user if they want to login instead and will
      // call the login function
      String email,
      String password,
      BuildContext context) async {
    try {
      // This will create a new user account
      await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      if (context.mounted) {
        // Pop the Sign in screen
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      // This will show a dialog if the email is already in use
      if (e.code == 'email-already-in-use' ||
          e.message.toString().contains('email-already-in-use')) {
        // we are doing message check because of the web version of firebase
        // check if the email is already in use
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // contentPadding: EdgeInsets.zero,
            icon: const Text(
              'Email already in use',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Would you like to login instead?'),
            actions: [
              TextButton(
                // This will call login func in the user if they choose to do so
                onPressed: () {
                  // Pop the dialog
                  Navigator.pop(context);
                  // Push the login screen
                  Navigator.pushNamed(context, Routes.loginRoute);
                },
                child: const Text('Login'),
              )
            ],
          ),
        );
      } else {
        errorDialog(
          context,
          'Authentication failed',
          'Something went wrong, please try again',
        );
      }
    } catch (e) {
      errorDialog(
        context,
        'Authentication failed',
        'Something went wrong, please try again',
      );
    }
  }

  // This function will login the user with email and password
  void loginAccount(String email, String password, BuildContext context) async {
    try {
      // This will login the user
      await _ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      if (context.mounted) {
        // pop the Login in screen
        Navigator.pop(context);
        // Pop the Sign in screen
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password' ||
          e.message.toString().contains('wrong-password')) {
        errorDialog(
          context,
          'Authentication failed',
          'Wrong password, please try again',
        );
      } else {
        errorDialog(
          context,
          'Authentication failed',
          'Something went wrong, please try again',
        );
      }
    } catch (e) {
      errorDialog(
        context,
        'Authentication failed',
        'Something went wrong, please try again',
      );
    }
  }

  // This function will sign out the user
  void signOut(BuildContext context) async {
    // This will sign out the user
    await GoogleSignIn().signOut();
    await _ref.read(firebaseAuthProvider).signOut();
    if (context.mounted) {
      // This will push the wrapper screen
      Navigator.pushReplacementNamed(context, Routes.wrapperRoute);
      // this will pop the current wrapper and push a new 
      // wrapper which will 
    }
  }

  void singInWithGoogle(BuildContext context) async {
    // This will sign in the user with google noth for Web and Mobile

    try {
      // This will check if the platform is web or not
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _ref.read(firebaseAuthProvider).signInWithPopup(googleProvider);
        if (context.mounted) {
          // pop the Sign in screen
          Navigator.pop(context);
        }
      } else {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // Sign in to firebase with the credential (Google)
        await _ref.read(firebaseAuthProvider).signInWithCredential(credential);
        if (context.mounted) {
          // pop the Sign in screen
          Navigator.pop(context);
        }
      }
    } catch (e) {
      errorDialog(
        context,
        e.toString(),
        ''
        // 'Something went wrong, please try again',
      );
    }
  }
  

  //
  // This function will send a password reset email and handle errors
  void resetPassword(String email, BuildContext context) async {
    try {
      // This will send a password reset email
      await _ref.read(firebaseAuthProvider).sendPasswordResetEmail(
            email: email,
          );
      if (context.mounted) {
        // This will show a snackbar if the email was sent
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent'),
          ),
        );
      }
    } catch (e) {
      // This will show a dialog if the email is not found
      errorDialog(
        context,
        'Authentication failed',
        'Something went wrong, please try again',
      );
    }
  }
}
